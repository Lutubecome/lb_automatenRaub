local models = {

    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm',

}

local function startTimer(timer)

    --print("Timer start")

    while timer > 0 do
            
        Citizen.Wait(1000)
        timer = timer - 1
        if timer == 0 then
            TriggerServerEvent('lb_automatenRaub:notRobbed')
            --print("Timer ende")
        end

    end

end


--hier script funktionen

local function startDrilling()

    lib.notify({

        title = 'Automat wird ausgeraubt!',
        type = 'inform',

    })

     

    TriggerServerEvent('lb_automatenRaub:gotRobbed')
    
    --remove Drill
    TriggerServerEvent('lb_automatenRaub:removeDrill')
    
    --lib.playAnim(source, 'anim@heists@fleeca_bank@drilling', 'drill_straight_end')
    if lib.skillCheck({'easy', 'easy', 'medium', 'medium'}, {'e'}) then

        --lib.playAnim(source, 'anim@scripted@player@mission@tun_table_grab@cash@heeled@', 'grab', 8, 8, 20010)

        
        
        
        if lib.progressCircle({
            duration = 15000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            allowCuffed = false,
            disable = {
                car = true,
                move = true,
                combat = true,
                sprint = true,
            },
            anim = {
                dict = 'anim@heists@fleeca_bank@drilling',
                clip = 'drill_straight_end'
            },
            prop = {
                model = 'ch_prop_ch_heist_drill',
                pos = vec3(0.13, 0.08, 0.35),
                rot = vec3(19, 20, 185)
            },
        }) then 

            lib.notify({

                title = 'Du hast den Automaten Aufgebrochen!',
                type = 'success',
    
            })

            --finish first
        
            if lib.progressCircle({
                duration = 10000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                    sprint = true,
                },
                anim = {
                    dict = 'anim@scripted@player@mission@tun_table_grab@cash@heeled@',
                    clip = 'grab'
                },        
            }) then 
            
                --finish all

                lib.notify({

                    title = 'Du hast das Geld!',
                    type = 'success',
        
                })

                --geld ausgabe

                local amount = math.random(1250, 2220)

                TriggerServerEvent('lb_automatenRaub:giveMoney', amount)
                --TriggerServerEvent('lb_automatenRaub:robbedFalse')
            else 
                
                lib.notify({

                    title = 'Du hast Abgebrochen!',
                    type = 'error',
        
                })

                --cancel 2
                --TriggerServerEvent('lb_automatenRaub:robbedFalse')
             end
        
        else 

            lib.notify({

                title = 'Du hast Abgebrochen!',
                type = 'error',
    
            })

            --cancel 1
            --TriggerServerEvent('lb_automatenRaub:robbedFalse')
         end

        



    else

        lib.notify({

            title = 'Du hast deinen Drill zerstoert!',
            type = 'error',

        })

        --TriggerServerEvent('lb_automatenRaub:robbedFalse')
    end

    startTimer(90)

end

lib.registerContext({
    id = 'lb_bankmenu',
    title = 'Automaten Raub',
    options = {
      {
        title = 'Ausrauben?',
        icon = 'vault',
        onSelect = function()

            if lib.callback.await('lb_automatenRaub:robbed') == false then
                
                if lib.callback.await('lb_automatenRaub:hasDrill') then
                    startDrilling()
                else

                    lib.notify({
                        title = 'Du hast keinen Drill!',
                        type = 'error'
                    })

                end
            else

                lib.notify({
                    title = 'Die Automaten wurde geleert, da erst ein Raub geschehen ist!',
                    type = 'inform'
                })

            end
        end,
      },
    }
  })
  

  --local pId = exports.qbx_core:GetPlayer(PlayerId())
  
 --[[ -- Function to create a marker
  local function createMarker(markerData)
  
  local marker = lib.marker.new({
    coords = markerData.coords - vec3(0, 0, 1.6),
    type = 1,
    color = { r = 255, g = 0, b = 0, a = 100 },
    width = 1,
  })


  -- Draw the marker and handle 'E' key press
  Citizen.CreateThread(function()
    
    while true do
        marker:draw()
    
        -- Check if player is near the marker and 'E' is pressed
        local playerCoords = GetEntityCoords(PlayerPedId())
        --print(playerCoords)
        local distance = #(playerCoords - markerData.coords)
        if distance < 1.0 and IsControlJustReleased(0, 51) then -- 38 is the key code for 'E'
        
            if lib.callback.await('lb_automatenRaub:hasDrill') == true then


                lib.showContext('lb_bankmenu')
            
            
            end
        
          
        
        end
    
        Citizen.Wait(1)
    end
  

  end)
  end
  

    for _, markerData in ipairs(markers) do
        createMarker(markerData)
        end

]]
  -- Loop through the markers array and create each marker
  Citizen.CreateThread(function ()
    
    exports.ox_target:addModel(models, {
        
        label = "Ausrauben?",
        icon = 'fas fa-vault',
        distance = 1.2,
        onSelect = function ()
                lib.showContext('lb_bankmenu')
        end

    })

  end)
