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
			player.aletear_presionado = true
		end
	else
		player.aletear_presionado = false
	end
end
-->8
-- pipes functions

--cREA UNA TUBERIA COMPLETA EN UNA POSICION X E Y. eL PARAMETRO CANT_BODYS ESPECIFICA CUANTOS BODIES DE 8PX HABRAN DEBAJO DEL TOP
function create_pipe(xpos, ypos, cant_bodys)
	
	--sIEMPRE SE CREA 1 UNICO TOP.
	local tuberia_top = {
									sprite = pipe_top.sprite,
									w = pipe_top.w,
									h = pipe_top.h,
									x = xpos,
									y = ypos
							}		
	
	--sIEMPRE SE CREA 1 BODY, MAX 4
	local tuberia_bodies = {}
	
	for i=1, cant_bodys do
		add(tuberia_bodies, {
			sprite = pipe_body.sprite,
			w = pipe_body.w,
			h = pipe_body.h,
			x = xpos,
			y = ypos + (8*(1+i)) --vAMOS BAJANDO DE A 8 PIXELES, QUE ES LA ALTURA DEL BODY
		})
	end
	
	--aGREGAMOS LAS TUBERIAS COMPLETAS A LA METATABLA
	add(pipes, {top = tuberia_top, bodies = tuberia_bodies })

end


function create_top_pipe(xpos, ypos, cant_bodys)
    -- sIEMPRE SE CREA UN UNICO TOP EN LA PARTE INFERIOR
    local tuberia_top = {
        sprite = pipe_top_superior.sprite,
        w = pipe_top.w,
        h = pipe_top.h,
        x = xpos,
        y = ypos - pipe_top.h  -- cOLOCAMOS EL TOP ENCIMA DE LOS BODIES
    }

    local tuberia_bodies = {}

    -- Colocamos los cuerpos de 8px uno encima de otro.
    for i = 1, cant_bodys do
        add(tuberia_bodies, {
            sprite = pipe_body.sprite,
            w = pipe_body.w,
            h = pipe_body.h,
            x = xpos,
            y = ypos - (8 * (1+ i))  -- Movemos los cuerpos hacia arriba (restando 8px por cada cuerpo)
        })
    end

    -- Agregamos las tuberれとas completas a la metatabla
    add(pipes, { top = tuberia_top, bodies = tuberia_bodies })
end




--mUEVE LOS TUBOS 1 PX A LA IZQUIERDA, ESTO PERMITE ANIMARLOS
function tube_animation(self)
	self.x = self.x - 1
	if self.x < -35 then
		self.x = 127
	end
end




-->8
--init

-- lA FUNCION INIT SE EJECUTA UNA SOLA VEZ AL INICIO DE CADA PROGRAMA
function _init()
		
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
		
		selector_animacion = 1
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
			sprite_actual = 0, --sprite actual
			sprites_animacion = animations[selector_animacion] , -- secuencia de sprites usados en la animacion para un flap
			animation_running = false,
			
			--gAMEPLAY
			aletear_presionado = false
			
		}
		
		--variables aux jugador
		gravedad = 0
	
		frame_counter = 0
		sprite_index = 1
		
		crear_tuberias_flag = true
	
		
		--[[
		 
		tuberias
		
		]]
		
		pipes = {} --mETATABLA
		
		--tAPA DE LA TUBERIA INFERIOR
		pipe_top = {
			--sPRITE: NRO, ALTO Y ANCHO
			sprite = 40,
			w = 4,
			h = 2,
			--uBICACION
			x = 60,
			y = 20
		}
		
		--tAPA DE LA TUBERIA SUPERIOR
		pipe_top_superior = {
			--sPRITE: NRO, ALTO Y ANCHO
			sprite = 44,
			w = 4,
			h = 2,
			
			x = 80,
			y = 40
		}
		
		--cUERPO (CUALQUIER TUBERIA)
		pipe_body = {
			--sPRITE: NRO, ALTO Y ANCHO
			sprite = 64,
			w = 4,
			h = 2,
			
			x = 80,
			y = 40
		}
		
		
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


end
-->8
--draw

--uTILIZADA POR _DRAW(), PERMITE 
function draw_pipes()
	for pipe in all(pipes) do
	
			--aCTUALIZAMOS LA XPOS DE TOP
			tube_animation(pipe.top)
	
		 --dIBUJAMOS EL TOP
   spr(pipe.top.sprite, 
   				pipe.top.x, 
   				pipe.top.y, 
   				pipe.top.w, 
   				pipe.top.h)
       
   -- dIBUJAMOS TODOS LOS BODIES
   for body in all(pipe.bodies) do
   	
   	--aCTUALIZAMOS LA XPOS DE BODY 
   	tube_animation(body)
   	
   	spr(body.sprite, 
   					body.x, 
   					body.y, 
   					body.w, 
   					body.h)
   end
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
		end
	
		--sE TERMINA LA ANIMACION IDLE, CREAMOS LAS TUBERIAS
		if inicio == true and crear_tuberias_flag == true then
			
			--lIMITE SUPERIOR (ESPACIO 50 PX)
			create_pipe(175,113,7)
			create_top_pipe(175,63,7)
			
			--lIMITE INFERIOR
			create_pipe(254,52,7)
			create_top_pipe(254,1,7)
			
			
			crear_tuberias_flag = false
		end
	
		if inicio == true then
		
			--dIBUJAMOS EL JUGADOR Y ANIMAMOS EL ALETEO CADA VEZ QUE SALTE
			spr(player.sprite_actual, player.xpos, player.ypos, 2, 2)
			flap_animation_button()	
			
			--dIBUJAMOS LAS TUBERIAS
			draw_pipes()
			
		end
		
	end
		
		
	if inicio == true and game_over == true then
		
		--lOGICA PARA TERMINAR LA PARTIDA
		--print("g a m e  o v e r")
		--stop()
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
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000cc00bb3333bbbb33bb33333333bb00cc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000cc00bb3333bbbb33bb33333333bb00cc
cccccc00000ccccccccccc00000ccccccccccc00000ccccccccccc00000ccccc00bbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000
cccc00778070cccccccc0077f070cccccccc0077f070cccccccc0077f070cccc00bbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000
ccc0778807770cccccc077ff07770cccccc077ff07770cccccc077ff07770ccc00bb3333bbbb33333333333333bb330000bbbbbbbbbbbbbbbbbbbbbbbbbbbb00
cc088888077070ccc0000fff077070cccc0fffff077070cccc0fffff077070cc00bb3333bbbb33333333333333bb330000bbbbbbbbbbbbbbbbbbbbbbbbbbbb00
c0888888077070cc077770ff077070ccc0ffffff077070ccc0ffffff077070cc00bb3333bbbb33bb333333333333bb0000bb3333bbbb33333333333333bb3300
c0888888807770cc0777770ff07770ccc00000fff07770ccc0fffffff07770cc00bb3333bbbb33bb333333333333bb0000bb3333bbbb33333333333333bb3300
c00000888800000c0677760fff00000c0777770fff00000cc00000ffff00000c00bb3333bbbb33bb3333333333bb330000bb3333bbbb33bb333333333333bb00
0f777f0880999990c06660fff08888800677760ff08888800677760ff088888000bb3333bbbb33bb3333333333bb330000bb3333bbbb33bb333333333333bb00
077770880900000ccc0005550800000cc00000550800000c077770550800000c00bb3333bbbb33bb333333333333bb0000bb3333bbbb33bb3333333333bb3300
077f08888099990ccc0555555088880ccc0555555088880c077605555088880c00bb3333bbbb33bb333333333333bb0000bb3333bbbb33bb3333333333bb3300
c0000888880000ccccc05555550000ccccc05555550000ccc0000555550000cc0000000000000000000000000000000000bb3333bbbb33bb333333333333bb00
cccc000000cccccccccc000000cccccccccc000000cccccccccc000000cccccc0000000000000000000000000000000000bb3333bbbb33bb333333333333bb00
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00bb3333bbbb33bb33333333bb00cc00000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00bb3333bbbb33bb33333333bb00cc00000000000000000000000000000000
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb333333bb3300cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc00bb3333bbbb33bb33333333bb00cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
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
__music__
00 01424344

