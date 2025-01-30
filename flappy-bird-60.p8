pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--flappy bird funcions

function check_start()

	--cHEQUEAMOS EL INICIO
	if btn(⬆️) or btn(⬇️) or btn(❎) or btn(🅾️) then
		inicio = true
	end
	
	--cAMBIO DE SKINS HACIA LA DER
	if btnp(➡️) then
	
		selector_animacion += 1
		
		
		if selector_animacion > 4 then
			selector_animacion = 1
		end
		
		player.sprites_animacion = animations[selector_animacion]
	end
	
	--cAMBIO DE SKINS HACIA LA IZQ
	if btnp(⬅️) then
		selector_animacion -= 1
		
		
		if selector_animacion < 1 then
			selector_animacion = 4
		end
		
		player.sprites_animacion = animations[selector_animacion]
	end
end


	
	
	



function flap_animation()
	-- aUMENTAMOS EL CONTADOR DE FRAMES, QUE SE EJECUTA UNA VEZ POR CADA UPDATE (A 60 FPS, EN ESTE CASO)
 frame_counter += 1
	
	-- cAMBIAMOS EL SPRITE CADA n FRAMES, EN ESTE CASO
 if frame_counter % 6 == 0 then
	 -- mOVER AL SIGUIENTE SPRITE
  sprite_index = (sprite_index % 4) + 1  -- alterna entre 1, 2 ... 5 (si fuese 10, pones %10)
  player.sprite_actual = player.sprites_animacion[sprite_index]  -- asigna el sprite a la variable
 end

 -- sI MOSTRAMOS TODOS LOS SPRITES, FRENAMOS LA ANIMACION Y REINICIAMOS LA SECUENCIA
 if sprite_index == 4 then
     player.animation_running = false 
 end
	
end

function flap_animation_button()
    if (btn(⬆️) or btn(⬇️) or btn(⬅️) or btn(➡️) or btn(❎) or btn(🅾️)) and not player.animation_running then
        player.animation_running = true  -- iNICIA LA ANIMACION
        frame_counter = 0  -- rEINICIAMOS LOS CONTADORES
        sprite_index = 1  
    end

    -- sI LA ANIMACION ESTA EN ESTADO RUNNING
    if player.animation_running then
       flap_animation()
    end
end



function gravedad_flappy()
	--mODIFICAMOS LA GRAVEDAD
	if player.ypos < 114 then
		player.ypos = player.ypos + gravedad
		gravedad = gravedad + 0.15
	else
		player.ypos = 114
		
		if game_over == false then
			sfx(02)
		end
		
		game_over = true
		
	end
	
	if player.ypos < -25 then
		player.ypos = -24
	end
	
end

function volar()
	--sALTO PRESIONADO? lA VARIABLE EXTRA "ALETEAR_PRESIONADO" PERMITE QUE NO SE SPAMEE EL BOTON	
	if btn(⬆️) or btn(⬇️) or btn(⬅️) or btn(➡️) or btn(❎) or btn(🅾️) then
		if player.aletear_presionado == false then
			gravedad = -2.2
			sfx(01)
			player.aletear_presionado = true
		end
	else
		player.aletear_presionado = false
	end
end

function final_flap()
	if bandera_final_flap == false then
		gravedad = -1.1
		bandera_final_flap = true
	end
end
-->8
-- pipes functions

--eLEGIMOS UN NRO RANDOM PARA LA TUBERIA SUPERIOR
function random_number(minimo, maximo)
	num = flr(rnd(maximo - minimo + 1) + minimo)
	return num
end

function add_points(pipe)
	--cALCULAMOS EL SCORE
	if pipe.top.lid.x + 9 == player.xpos then
		points += 1
		sfx(00)
	end
end



function check_collision(pipe)
	--sI LA PARTE INFERIOR DE PLAYER
	--ES MAYOR A LA PARTE SUPERIOR
	--DE LA TAPA DE LA TUBERIA INF.
	--SIGNIFICA QUE LA TRASPASO,
	--ERGO HAY COLISION
	
	--nota: eSTO OCURRE ASI YA QUE
	--EN PICO8, EL PISO ES Y = 128
	--MIENTRAS QUE EL TECHO ES Y=0
	
	
	--cOLLISION BOTTOM PIPE
	if (player.ypos+12 > pipe.bottom.lid.y) --cOLISION CON EL TECHO DE PIPE.BOTTOM.LID
				and	
				( player.xpos+14  > pipe.bottom.lid.x ) --cOLISION CON EL LADO IZQ DE PIPE.BOTTOM.LID
				and
				(player.xpos+5    < pipe.bottom.lid.x + 32) --cOLISION CON EL LADO DER DE PIPE.BOTTOM.LID
				then
				
				if player.ypos <110 then
					sfx(02)
				end
			game_over = true
			tuberia_colision = pipe
				
	end
	
	--cOLLISION TOP PIPE
	if (player.ypos < pipe.top.lid.y+12) --cOLISION CON PARTE INFERIOR DE PIPE.TOP.LID.Y 
				and	
				( player.xpos+14  > pipe.top.lid.x ) --cOLISION CON PARTE IZQ DE PIPE.TOP.LID.X
				and
				(player.xpos+5    < pipe.top.lid.x + 32) --cOLISION CON PARTE DER DE PIPE.TOP.LID.X
				then
			
			if player.ypos < 100 then
					sfx(02)
				end
			game_over = true
			tuberia_colision = pipe
				
	end
	
	

end

function move_pipe(pipe)

	--gENERAMOS UN NRO ALEATORIO
	local num = random_number(0, 62)
	
	--sUMAMOS 1 A POINTS
	add_points(pipe)
	
	--cHEQUEAMOS COLISIONES
	check_collision(pipe)
	
	
	
	--[[
	movimiento top
	]]
	
	--mOVEMOS LA TAPA
	pipe.top.lid.x -= 1
	
	--mOVEMOS LOS BODYS
	for i = 1, 4 do
		--sUBCADENA PARA LAS PART1, PART2, ETC
		p_top = pipe.top.body["part"..i]
		
		--cICLAMOS CON AYUDA DE LA STR
		p_top.x -= 1
	end
	
	
	--randomizacion y loop 
	if pipe.top.lid.x < -35 then
		pipe.top.lid.x = 127
		pipe.top.lid.y = num
		
			--mOVEMOS LOS BODYS
		for i = 1, 4 do
			--sUBCADENA PARA LAS PART1, PART2, ETC
			p_top = pipe.top.body["part"..i]
			
			--cICLAMOS CON AYUDA DE LA STR
			p_top.x = 127
			p_top.y = num-(16*i)
		end
	end
	
	
	--[[
	movimiento bottom
	]]
	
	--mOVEMOS LA TAPA
	pipe.bottom.lid.x -= 1
	
	--mOVEMOS LOS BODYS
	for i = 1, 4 do
		--sUBCADENA PARA LAS PART1, PART2, ETC
		p_bottom = pipe.bottom.body["part"..i]
		
		--cICLAMOS CON AYUDA DE LA STR
		p_bottom.x -= 1
	end
	
	
	--randomizacion y loop
	if pipe.bottom.lid.x < -35 then
		pipe.bottom.lid.x = 127
		pipe.bottom.lid.y = num + pipe.space
		
			--mOVEMOS LOS BODYS
		for i = 1, 4 do
			--sUBCADENA PARA LAS PART1, PART2, ETC
			p_bottom = pipe.bottom.body["part"..i]
			
			--cICLAMOS CON AYUDA DE LA STR
			p_bottom.x = 127
			p_bottom.y = num + (16 * i) + pipe.space
		end
	end
	
	
end



function init_pipes()

	--tUBERIA COMPLETA 1
	
	--eLEGIMOS UN NRO RANDOM ENTRE
	--0 Y 62, QUE CORRESPONDE A LA
	--ALTURA MIN Y MAX DE LA PORCION
	--TOP DE UNA PIPE. dESPUES, EN 
	--BASE A ESTE NRO, SUMAMOS EL 
	--ESPACIO ENTRE TUBERIAS Y OBT.
	--LAS POSICIONES PARA EL BOTTOM
	num = random_number(0, 62)
	 
		pipe1 = {
		
			--eSPACIO ENTRE LAS MITADES
			space = space_init,
			
			--mITAD SUPERIOR COMPLETA
			top = {
				
					lid = {
						sprite = 40,
						w = 4,
						h = 2,
						x = 175,
						y = num,
						mirror = false,
						flp = true
					},
					
				body = {
					part1 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num-(16*1),
						mirror = false,
						flp = true
					},
					
					part2 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num-(16*2),
						mirror = false,
						flp = true
					},
					
					part3 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num-(16*3),
						mirror = false,
						flp = true
					},
					
					part4 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num-(16*4),
						mirror = false,
						flp = true
					},
				},
			},
			
			
			--mITAD INFERIOR
			
			--pARA UBICARLA, SUMAMOS EL
			--ESPACIO DE SEPARACION AL 
			--VALOR DE X Y SUMAMOS 16 PARA
			--C/U DE LOS BODYES
			bottom = {
				
					lid = {
						sprite = 40,
						w = 4,
						h = 2,
						x = 175,
						y = num + space_init,
						mirror = false,
						flp = false
					},
				
				body = {
					part1 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num + (16 * 1) + space_init,
						mirror = false,
						flp = false
					},
					
					part2 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num + (16 * 2) + space_init,
						mirror = false,
						flp = false
					},
					
					part3 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num + (16 * 3) + space_init,
						mirror = false,
						flp = false
					},
					
					part4 = {
						sprite = 44,
						w = 4,
						h = 2,
						x = 175,
						y = num + (16 * 4) + space_init,
						mirror = false,
						flp = false
					},
				
				},				
				
				
			}
		}
		
		
		--tUBERIA COMPLETA 2
		
		num = random_number(0, 62) 
		pipe2 = {
		
			--eSPACIO ENTRE LAS MITADES
			space = space_init,
			
			--mITAD SUPERIOR COMPLETA
			top = {
				
					lid = {
						sprite = 40,
						w = 4,
						h = 2,
						x = 254,
						y = num,
						mirror = false,
						flp = true
					},
					
					body = {
					
						part1 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num-(16*1),
							mirror = false,
							flp = true
						},
				
						part2 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num-(16*2),
							mirror = false,
							flp = true
						},
						
						part3 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num-(16*3),
							mirror = false,
							flp = true
						},
						
						part4 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num-(16*4),
							mirror = false,
							flp = true
						},
					},
			},
			
			
			--mITAD INFERIOR
			bottom = {
				
					lid = {
						sprite = 40,
						w = 4,
						h = 2,
						x = 254,
						y = num + space_init,
						mirror = false,
						flp = false
					},
					
					body = {
					
						part1 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num + (16 * 1) + space_init,
							mirror = false,
							flp = false
						},
						
						part2 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num + (16 * 2) + space_init,
							mirror = false,
							flp = false
						},
						
						part3 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num + (16 * 3) + space_init,
							mirror = false,
							flp = false
						},
						
						part4 = {
							sprite = 44,
							w = 4,
							h = 2,
							x = 254,
							y = num + (16 * 4) + space_init,
							mirror = false,
							flp = false
						},
						
					}
					
				}
				

		}
		
end


-->8
--init
selector_animacion = 1

-- lA FUNCION INIT SE EJECUTA UNA SOLA VEZ AL INICIO DE CADA PROGRAMA
function _init(selector_animacion)
		
		--[[
		
		background
		
		]]
		background_color = 12
		palt(0,false) --el negro no es transparente
		palt(12,true) --el celeste es transparente
		cls(background_color)
		
		
		--[[ 
		
		jugador - flappy bird
		
		]]
		
		points = 0
		
		selector_animacion = selector_animacion or 1
		animations = {
			{2, 4, 2, 0},					--1 / aMARILLO
			{8, 10, 8, 6},				--2 / rOSA
			{14, 32, 14, 12}, --3 / rOJO
			{36, 38, 36, 34}		--4 / gRIS
		}
				
		player = {
			--pOSICION SPRITE
			xpos = 30,
			ypos = 55,
			
			-- aNIMACION FLAP
			sprite_actual = animations[selector_animacion][1], --sprite actual
			sprites_animacion = animations[selector_animacion] , -- secuencia de sprites usados en la animacion para un flap
			animation_running = false,
			
			--gAMEPLAY
			aletear_presionado = false
			
		}
		
		--variables aux jugador
		gravedad = 0
		bandera_final_flap = false
		
		frame_counter = 0
		sprite_index = 1
	
	
		
		--[[
		 
		tuberias
		
		]]
		tuberia_colision = false
		space_init = 50
		init_pipes()
		
		

		--[[
		
		other variables
		
		]]
		
		inicio = false
		game_over = false
	
		
		
	
		
end
-->8
--update60

--alternativamente _update(), actualiza las cosas 30 o 60 veces por segundo antes de dibujar las cosas	
function _update60()	

	if inicio == false and game_over == false then
		--eL PAJARO VUELA ESTATICO HASTA QUE SE PRESIONA UNA TECLA, MOMENTO EN EL CUAL LA GRAVEDAD ENTRA EN EFECTO
		check_start()
	end	

	
	if inicio == true and game_over == false then
		gravedad_flappy()
		volar()
	end
	
	if inicio == true and game_over == true then
		if (btn(⬅️) or btn(➡️) ) then
    _init(selector_animacion)
  end
	end


end
-->8
--draw

function draw_pipe_no_mov(pipe)
	if ((tuberia_colision) != false) then
	

		--top pipe
		spr(pipe.top.lid.sprite, 
						pipe.top.lid.x,
						pipe.top.lid.y, 
						pipe.top.lid.w, 
						pipe.top.lid.h, 
						pipe.top.lid.mirror, 
						pipe.top.lid.flp
						)
						
		for i = 1, 4 do
			--sUBCADENA PARA LAS PART1, PART2, ETC
			p_top = pipe.top.body["part"..i]
			
			--cICLAMOS CON AYUDA DE LA STR
			spr(p_top.sprite,
							p_top.x,
							p_top.y,
							p_top.w,
							p_top.h,
							p_top.mirror,
							p_top.flp)
		end				
		
		
		--bottom pipe
			spr(pipe.bottom.lid.sprite, 
						pipe.bottom.lid.x,
						pipe.bottom.lid.y, 
						pipe.bottom.lid.w, 
						pipe.bottom.lid.h, 
						pipe.bottom.lid.mirror, 
						pipe.bottom.lid.flp)		
		
			for i = 1, 4 do
			--sUBCADENA PARA LAS PART1, PART2, ETC
			p_bottom = pipe.bottom.body["part"..i]
				spr(p_bottom.sprite,
								p_bottom.x,
								p_bottom.y,
								p_bottom.w,
								p_bottom.h,
								p_bottom.mirror,
								p_bottom.flp)
			end
		end
end

function draw_pipe(pipe)

	--mOVEMOS LA TUBERIA, 
	--AUMENTAMOS LA SCORE
	--CHEQUEAMOS COLISIONES
	move_pipe(pipe)

	--top pipe
	spr(pipe.top.lid.sprite, 
					pipe.top.lid.x,
					pipe.top.lid.y, 
					pipe.top.lid.w, 
					pipe.top.lid.h, 
					pipe.top.lid.mirror, 
					pipe.top.lid.flp
					)
					
	for i = 1, 4 do
		--sUBCADENA PARA LAS PART1, PART2, ETC
		p_top = pipe.top.body["part"..i]
		
		--cICLAMOS CON AYUDA DE LA STR
		spr(p_top.sprite,
						p_top.x,
						p_top.y,
						p_top.w,
						p_top.h,
						p_top.mirror,
						p_top.flp)
	end				
	
	
	--bottom pipe
		spr(pipe.bottom.lid.sprite, 
					pipe.bottom.lid.x,
					pipe.bottom.lid.y, 
					pipe.bottom.lid.w, 
					pipe.bottom.lid.h, 
					pipe.bottom.lid.mirror, 
					pipe.bottom.lid.flp)		
	
		for i = 1, 4 do
		--sUBCADENA PARA LAS PART1, PART2, ETC
		p_bottom = pipe.bottom.body["part"..i]
			spr(p_bottom.sprite,
							p_bottom.x,
							p_bottom.y,
							p_bottom.w,
							p_bottom.h,
							p_bottom.mirror,
							p_bottom.flp)
		end
end



--dibujamos cosas segun lo que calculamos en update
function _draw()
	if game_over == false then

		cls(background_color)
		
		--aNIMACION IDLE
		if inicio == false then
		
			
			spr(player.sprite_actual, player.xpos, player.ypos, 2, 2)
			flap_animation()
			
			
			color(15)
			print("")
			print("")
			print("")
			print("")
			print("")
			print("")
			print("    f l a p p i c o  b i r d  ")	
			print("")
			print("")
			print("")
			print("")
			print("")
			print("")	
			print("        fLY WITH ANY KEY")
			print("   cHANGE SKINS WITH ⬅️ OR ➡️")
			print("")	
			print("")	
			print("")
			print("")
			color(0)	
			print("     iGNACIO mOSCONI - 2025")
		end
		
	
		if inicio == true then
		
		
			--dIBUJAMOS EL JUGADOR Y ANIMAMOS EL ALETEO CADA VEZ QUE SALTE
			spr(player.sprite_actual, player.xpos, player.ypos, 2, 2)
			flap_animation_button()	
			
			--dIBUJAMOS LAS TUBERIAS
			draw_pipe(pipe1)
			draw_pipe(pipe2)
			
			--mOSTRAMOS LA PUNTUACION
			color(15)
			print("          s c o r e: "..points)
 
		end
		
		
	end
		
		
	if inicio == true and game_over == true then
		
		--lOGICA PARA TERMINAR LA PARTIDA
		cls(12)
		
		spr(player.sprite_actual, player.xpos, player.ypos, 2, 2)
		
		gravedad_flappy() --eL JUGADOR CAE
		final_flap()						--uLTIMO ALETEO
		draw_pipe_no_mov(tuberia_colision) --mOSTRAMOS LAS TUBERIAS CON LAS QUE CHOCO
		
		
		print("")
		print("")
		print("")
		print("")
		print("")
		print("                         g")
		print("                         a")
		print("                         m")
		print("                         e")
		print("")
		print("                         o")
		print("                         v")
		print("                         e")
		print("                         r")
		print("")
		print("")
		
		print("                      score:".. points)
		print("")
		print("                    rESTART WITH")
		print("                     ⬅️  or  ➡️ ") 
		
		
		

		

	end
		
	
	
	
	
	--dEBUGS
	--print("gravedad:".. gravedad .." | ypos:" .. player.ypos)
 --print("player sprite:" .. player.sprite_actual)
end
__gfx__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccc
cccc0077a070cccccccc0077a070cccccccc0077a070cccccccc0077e070cccccccc0077e070cccccccc0077e070cccccccc00778070cccccccc00778070cccc
ccc077aa07770cccccc077aa07770cccccc077aa07770cccccc077ee07770cccccc077ee07770cccccc077ee07770cccccc0778807770cccccc0778807770ccc
c0000aaa077070cccc0aaaaa077070cccc0aaaaa077070ccc0000eee077070cccc0eeeee077070cccc0eeeee077070ccc0000888077070cccc088888077070cc
077770aa077070ccc0aaaaaa077070ccc0aaaaaa077070cc077770ee077070ccc0eeeeee077070ccc0eeeeee077070cc07777088077070ccc0888888077070cc
0777770aa07770ccc00000aaa07770ccc0aaaaaaa07770cc0777770ee07770ccc00000eee07770ccc0eeeeeee07770cc07777708807770ccc0000088807770cc
0f777f0aaa00000c0777770aaa00000cc00000aaaa00000c0f777f0eee00000c0777770eee00000cc00000eeee00000c0f777f088800000c077777088800000c
c0fff0aaa08888800f777f0aa08888800f777f0aa0888880c0fff0eee08888800f777f0ee08888800f777f0ee0888880c0fff088809999900f777f0880999990
cc0009990800000cc00000990800000c077770990800000ccc0002220800000cc00000220800000c077770220800000ccc0008880900000cc00000880900000c
cc0999999088880ccc0999999088880c077f09999088880ccc0222222088880ccc0222222088880c077f02222088880ccc0888888099990ccc0888888099990c
ccc09999990000ccccc09999990000ccc0000999990000ccccc02222220000ccccc02222220000ccc0000222220000ccccc08888880000ccccc08888880000cc
cccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000cc00bb3333bbbb33bb333333bb3300cc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000cc00bb3333bbbb33bb333333bb3300cc
cccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccc00bbbbbbbbbbbbbbbbbbbbbbbbbbbb00cc00bb3333bbbb33bb33333333bb00cc
cccc00778070cccccccc0077f070cccccccc0077f070cccccccc0077f070cccc00bbbbbbbbbbbbbbbbbbbbbbbbbbbb00cc00bb3333bbbb33bb33333333bb00cc
ccc0778807770cccccc077ff07770cccccc077ff07770cccccc077ff07770ccc00bb3333bbbb33333333333333bb3300cc00bb3333bbbb33bb333333bb3300cc
cc088888077070ccc0000fff077070cccc0fffff077070cccc0fffff077070cc00bb3333bbbb33333333333333bb3300cc00bb3333bbbb33bb333333bb3300cc
c0888888077070cc077770ff077070ccc0ffffff077070ccc0ffffff077070cc00bb3333bbbb33bb333333333333bb00cc00bb3333bbbb33bb33333333bb00cc
c0888888807770cc0777770ff07770ccc00000fff07770ccc0fffffff07770cc00bb3333bbbb33bb333333333333bb00cc00bb3333bbbb33bb33333333bb00cc
c00000888800000c0677760fff00000c0777770fff00000cc00000ffff00000c00bb3333bbbb33bb3333333333bb3300cc00bb3333bbbb33bb333333bb3300cc
0f777f0880999990c06660fff08888800677760ff08888800677760ff088888000bb3333bbbb33bb3333333333bb3300cc00bb3333bbbb33bb333333bb3300cc
077770880900000ccc0005550800000cc00000550800000c077770550800000c00bb3333bbbb33bb333333333333bb00cc00bb3333bbbb33bb33333333bb00cc
077f08888099990ccc0555555088880ccc0555555088880c077605555088880c00bb3333bbbb33bb333333333333bb00cc00bb3333bbbb33bb33333333bb00cc
c0000888880000ccccc05555550000ccccc05555550000ccc0000555550000cc00000000000000000000000000000000cc00bb3333bbbb33bb333333bb3300cc
cccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccc00000000000000000000000000000000cc00bb3333bbbb33bb333333bb3300cc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00bb3333bbbb33bb33333333bb00cccc00bb3333bbbb33bb33333333bb00cc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00bb3333bbbb33bb33333333bb00cccc00bb3333bbbb33bb33333333bb00cc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccfffcccccfcccccccfffcccccfffcccccfffcccccfffccccccffccccccffcccccccccfffcccccfffcccccfffcccccffcccccccccccccccccc
ccccccccccccccccfcccccccfcccccccfcfcccccfcfcccccfcfccccccfccccccfcccccccfcfcccccccccfcfccccccfccccccfcfcccccfcfccccccccccccccccc
ccccccccccccccccffccccccfcccccccfffcccccfffcccccfffccccccfccccccfcccccccfcfcccccccccffcccccccfccccccffccccccfcfccccccccccccccccc
ccccccccccccccccfcccccccfcccccccfcfcccccfcccccccfccccccccfccccccfcccccccfcfcccccccccfcfccccccfccccccfcfcccccfcfccccccccccccccccc
ccccccccccccccccfcccccccfffcccccfcfcccccfcccccccfcccccccfffccccccffcccccffccccccccccfffcccccfffcccccfcfcccccfffccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccc00000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccc0077a070cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccc077aa07770ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccc0aaaaa077070cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccc0aaaaaa077070cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccc00000aaa07770cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccc0777770aaa00000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccc0f777f0aa0888880cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccc00000990800000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccc0999999088880ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccc09999990000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccc000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccfffccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccfcccfcccfcfcccccfcfcfffcfffcfcfccccccffcffccfcfcccccfcfcfffcfcfccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccffccfcccfffcccccfcfccfcccfccfcfcccccfcfcfcfcfffcccccffccffccfffccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccfcccfcccccfcccccfffccfcccfccfffcccccfffcfcfcccfcccccfcfcfcccccfccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccfccccffcffccccccfffcfffccfccfcfcccccfcfcfcfcffccccccfcfccffcffcccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccffccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccfffffcccccccccccccccccccfffffcccccccccccccc
ccccccccccccfcccfcfccffcffcccffcfffccccccffcfcfcfffcffcccffcccccfcfcfffcfffcfcfcccccfffccffccccccffcffccccccffccfffccccccccccccc
ccccccccccccfcccfcfcfcfcfcfcfcccffccccccfcccffcccfccfcfcfcccccccfcfccfcccfccfcfcccccffcccffcccccfcfcfcfcccccffcccffccccccccccccc
ccccccccccccfcccfffcfffcfcfcfcfcfcccccccccfcfcfccfccfcfcccfcccccfffccfcccfccfffcccccfffccffcccccfcfcffccccccffccfffccccccccccccc
cccccccccccccffcfcfcfcfcfcfcfffccffcccccffccfcfcfffcfcfcffccccccfffcfffccfccfcfccccccfffffccccccffccfcfccccccfffffcccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccc000ccccccccccccccccccccccccccccc000ccccccccccccccccccccccccccccccccccccc000c000c000c000ccccccccccccccccccccc
ccccccccccccccccccccc0ccc00c00ccc00cc00c000cc00ccccc000cc00cc00cc00cc00c00cc000ccccccccccccccc0c0c0ccc0c0ccccccccccccccccccccccc
ccccccccccccccccccccc0cc0ccc0c0c0c0c0cccc0cc0c0ccccc0c0c0c0c0ccc0ccc0c0c0c0cc0cccccc000ccccc000c0c0c000c000ccccccccccccccccccccc
ccccccccccccccccccccc0cc0c0c0c0c000c0cccc0cc0c0ccccc0c0c0c0ccc0c0ccc0c0c0c0cc0cccccccccccccc0ccc0c0c0ccccc0ccccccccccccccccccccc
cccccccccccccccccccc000c000c0c0c0c0cc00c000c00cccccc0c0c00cc00ccc00c00cc0c0c000ccccccccccccc000c000c000c000ccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

__map__
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
610a000039000380103d0103d0103e0000000021000240003c0002c00030000330003500036000160001400014000130001200011000100000e0000e0000f0002400000000000000000000000000000000000000
94010000073100b310163101b3202162022610246101d61016610116100a40005400000002160025600286002c6002f600326003260031600306002f6002d600276001c600007000070000700007000070000700
4e0100003e6303d6303c6303c6303c6303d6303c6303763034620306202b62029620266202462021620206201f6201e6201d6201a6201562012620106100e6100c61008610056100561000600006000060000600
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
042000001885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
