local RaelHubMemeSea = {}
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerGui = LocalPlayer.PlayerGui
local QuestScreen = PlayerGui.QuestGui.Holder.QuestSlot1
local QuestLocaion = workspace.Location.QuestLocaion
local QuestsNpc = workspace.NPCs.Quests_Npc
local Monsters = workspace.Monster

getgenv().EquipStyle = "Melee" -- or Weapons
getgenv().MonsterName = ""
getgenv().NpcQuest = ""
getgenv().HeightPlayer = 7
getgenv().RaelHubGetLevel = true
getgenv().RaelHubAutoFarm = false
getgenv().RaelHubAutoClicker = false
getgenv().RaelHubAutoClickCat = false

-- Auto Farm

local GetFightingStyle = loadstring(game:HttpGet("https://raw.githubusercontent.com/Laelmano24/Meme-Sea/refs/heads/main/Equip%20Style.lua"))()

local GetListMonsters = loadstring(game:HttpGet("https://raw.githubusercontent.com/Laelmano24/Meme-Sea/refs/heads/main/MemeSea%20Monsters%20List.lua"))()

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
end)

function RaelHubMemeSea.GetLevelAndQuest(value)
  
  getgenv().RaelHubGetLevel = value
  
  task.spawn(function()
    while getgenv().RaelHubGetLevel do
  
      local QuestFloppas = PlayerGui.GameGui.Compass.Main.Container.Quest.Container
  
      local function GetNumberFromString(text)
    
      local numero = text:match("%d+")
        return tonumber(numero)
      end
  
      for _, FloppasQuest in ipairs(QuestFloppas:GetChildren()) do
        local Trackframe = FloppasQuest:FindFirstChild("TrackFrame")
    
        if Trackframe then
          local recommended = Trackframe.Track.Recommended
      
          if recommended and recommended.Visible then
            local Number =  GetNumberFromString(FloppasQuest.Name)
        
            for i, valor in ipairs(GetListMonsters) do
              if tostring(Number) == "23" or tostring(Number) == "29" or tostring(Number) == "32" then
              
                local NewNumber = Number - 1
              
                local NewFloppaQuest = "Floppa Quest " .. NewNumber
              
                if i == NewNumber then
                
                  getgenv().MonsterName = valor
                  getgenv().NpcQuest = NewFloppaQuest
                  break
                end
              else
                if i == Number then
                  getgenv().MonsterName = valor
                  getgenv().NpcQuest = FloppasQuest.Name
                  break
                end
              end
            end
            break
          end
        end
      end
      task.wait(2)
    end
  end)
end

function CheckQuest()
  local questgiver = QuestScreen:FindFirstChild("QuestGiver")
  if questgiver and QuestScreen.Visible and questgiver.Text == getgenv().NpcQuest then
    return true
  else
    if questgiver and QuestScreen.Visible and questgiver.Text ~= getgenv().NpcQuest then
      task.wait(0.3)
      local args = {
        [1] = "Abandon_Quest",
        [2] = {
          ["QuestSlot"] = "QuestSlot1"
        }
      }

      game:GetService("ReplicatedStorage").OtherEvent.QuestEvents.Quest:FireServer(unpack(args))
    end
    return false
  end
end

function GetQuest(npcquest)
  while getgenv().RaelHubAutoFarm and not CheckQuest() do
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and QuestsNpc:FindFirstChild(npcquest) then
      Character:MoveTo(QuestLocaion[npcquest].Position)
      task.wait()
      if QuestsNpc:FindFirstChild(npcquest) then
        fireproximityprompt(QuestsNpc[npcquest].Block.QuestPrompt)
      end
    end
    task.wait()
  end
end

function TeleportToMonster(monster)
  while monster.Parent and getgenv().RaelHubAutoFarm and CheckQuest() do
    if monster then
      local HumanoidRootPart = monster:FindFirstChild("HumanoidRootPart")
      if HumanoidRootPart then
        local position = HumanoidRootPart.Position
        local altura = position + Vector3.new(0, getgenv().HeightPlayer, 0)
        local rotation = Vector3.new(-90, 0, 180)

        if Character and Character:FindFirstChild("HumanoidRootPart") then
          Character.HumanoidRootPart.CFrame = CFrame.new(altura) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
        end
      end
      task.wait()
    end
  end
end

function CheckDistance()
  
 local humanoidrootpart = Character:FindFirstChild("HumanoidRootPart")
  local MonsterPart = workspace.Location.Enemy_Location[getgenv().MonsterName]
  
  if MonsterPart and humanoidrootpart then
    local PlayerPosition = humanoidrootpart.Position
    local MonsterPosition = MonsterPart.Position
    
    local Distance = (PlayerPosition - MonsterPosition).Magnitude
    
    if Distance >= 500 then
      humanoidrootpart.CFrame = CFrame.new(MonsterPosition)
    end
  end
end

function Function_EquipStyle()
  local BackPack = LocalPlayer:FindFirstChild("Backpack")
  local Humanoid = Character:FindFirstChild("Humanoid")
  if BackPack and Humanoid then
    if getgenv().EquipStyle == "Weapons" then
      for _, Style in ipairs(GetFightingStyle.weapons()) do
        local Tool = BackPack:FindFirstChild(Style)
        if Tool then
          Humanoid:EquipTool(Tool)
        end
      end
    elseif getgenv().EquipStyle == "Melee" then
      
      for _, Style in ipairs(GetFightingStyle.melee()) do
        local Tool = BackPack:FindFirstChild(Style)
        if Tool then
          Humanoid:EquipTool(Tool)
        end
      end
    end
  end
end

function RaelHubMemeSea.AutoFarm(value)
  
  getgenv().RaelHubAutoFarm = value
  
  task.spawn(function()
    while getgenv().RaelHubAutoFarm do
      CheckDistance()
      Function_EquipStyle()
      task.wait()
    end
  end)
 
  task.spawn(function()
    while getgenv().RaelHubAutoFarm do
      GetQuest(getgenv().NpcQuest)
      for _, Monster in ipairs(Monsters:GetChildren()) do
        if Monster.Name == getgenv().MonsterName then
          TeleportToMonster(Monster)
        end
      end
      task.wait()
    end
  end)
end

function RaelHubMemeSea.AutoClicker(value)
  
  function autoClick()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(1e4, 1e4))
    task.wait(0.05)
  end
  
  getgenv().RaelHubAutoClicker = value
  
  task.spawn(function()
    while getgenv().RaelHubAutoClicker do
      autoClick()
    end
  end)
end

RaelHubMemeSea.GetLevelAndQuest(true)

-- Auto click cat

function RaelHubMemeSea.AutoClickCat(value)
  
  getgenv().RaelHubAutoClickCat = value
  
  while getgenv().RaelHubAutoClickCat do
    
    fireclickdetector(workspace.Island.FloppaIsland.Popcat_Clickable.Part.ClickDetector)
    task.wait(0.005)
          
  end
  
end

function RaelHubMemeSea.ShowClickCat()
  
  local FloppaIsland = workspace.Island:FindFirstChild("FloppaIsland")
  
  if FloppaIsland then
    local Popcat_Clickable = FloppaIsland:FindFirstChild("Popcat_Clickable")
    
    if Popcat_Clickable then
      return Popcat_Clickable.Part.BillboardGui.Textlabel.Text
    end
  end
end

warn("All functions have been loaded")
warn("Thank you for using Rael's modules (Laelmano24)")

return RaelHubMemeSea