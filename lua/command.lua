-- [[ Service Declarations ]] --

local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local pathFindingService = game:GetService("PathfindingService")

-- [[ Client Declarations ]] --

local client = players.LocalPlayer

-- [[ Variable Declarations ]] --

--// UI Cache

local screenGui

--// Command Related

local commands = {}

local active = true
local onGoingLocate = false

local config = {
	prefix = ">",
	separator = " "
}

-- [[ Function Declarations ]] --

local function runCommand(inputBox)
	return function(pressedEnter)
        if not pressedEnter then return end
        if not active then return end
		
		local currentPrefix = config.prefix
		local currentSeparator = config.separator
		
		local commandString = inputBox.Text
		
		if commandString:sub(1, #currentPrefix) == currentPrefix then
			commandString = commandString:sub(#currentPrefix + 1, #commandString):lower()
			
			local args = commandString:split(currentSeparator)
			local inputtedCommand = table.remove(args, 1)
			
			local reference = commands[inputtedCommand]
			
			if reference then
				local success, response = pcall(reference, unpack(args))
				
				if success then
					inputBox.Text = response
				end
			end
		end
	end
end

local function getPlayerFromPartialUsername(partialUsername)
	local partialUsername = partialUsername:lower()
	local playersIngame = players:GetPlayers()

	for i, player in pairs(playersIngame) do
		local username = player.Name:lower()
		
		if username:sub(1, #partialUsername) == partialUsername then
			return player
		end
	end
end

-- [[ Module Declarations ]] --

--// Dictionary Module Declaration

local dictionary = {}

do
	--// Dictionary Methods
	
	function dictionary.remove(dictionary, index)
		local reference = dictionary[index]
		
		dictionary[index] = nil
		
		return reference
	end
end

--// Command Module Declaration

local command = {}

do
	--// Command Methods
	
	local commandMethods = {}
	
	commandMethods.__index = commandMethods
	
	function command.new(aliases, callback)
		local newCommand = {
			aliases = aliases,
			callback = callback
		}
		
		for i, alias in pairs(aliases) do
			commands[alias:lower()] = callback
		end
		
		setmetatable(newCommand, commandMethods)
	end
	
	function commandMethods:destroy()
		local aliases = self.aliases
		
		for i, alias in pairs(aliases) do
			commands[alias:lower()] = nil
		end
	end
end

--// Instance Module Declaration

local instance = {}

do
	--// Instance Methods
	
	function instance.new(class, properties)
		local newInstance = Instance.new(class)
		local parent = dictionary.remove(properties, "Parent")
		
		for propertyName, propertyValue in pairs(properties) do
			newInstance[propertyName] = propertyValue
		end
		
		if parent then
			newInstance.Parent = parent
		end
		
		return newInstance
	end
end

-- [[ Init ]] --

do
	--// Construct Input Interface
	
	screenGui = instance.new("ScreenGui", {
		Parent = coreGui
	})
	
	local inputBox = instance.new("TextBox", {
		TextScaled = true,
		Text = "",
		BorderSizePixel = 2,
		Font = Enum.Font.Code,
		BackgroundColor3 = Color3.new(1, 1, 1),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(.125, 0, .025, 0),
		Parent = screenGui
	})
	
	inputBox.FocusLost:Connect(runCommand(inputBox))
end

do
	--// Construct Commands

    command.new(
        {
            "panic",
            "deactivate",
            "stop",
            "exit",
            "quit",
            "bye"
        }, 
        function()
            active = false
            debris:AddItem(screenGui, 2)

			return "Closing Shortly."
        end
    )


    command.new(
        {
            "locate",
            "walk",
            "path"
        },
        function(targetName)
            if onGoingLocate then return "Error [Currently Locating]" end
            local target = getPlayerFromPartialUsername(targetName)

            if targetName == "$random" then
                local playersIngame = players:GetPlayers()
                local randomIndex = math.random(1, #playersIngame)
                local randomPlayer = playersIngame[randomIndex]

                target = randomPlayer
            end
            
            if target then
                local clientCharacter = client.Character
                local targetCharacter = target.Character
                
                local clientHumanoid = clientCharacter:FindFirstChild("Humanoid")

                local clientRoot = clientCharacter:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if clientHumanoid and clientRoot and targetRoot then
                    local path = pathFindingService:CreatePath()
                    
                    path:ComputeAsync(clientRoot.Position, targetRoot.Position)

                    local waypoints = path:GetWaypoints()

                    coroutine.wrap(function()
                        onGoingLocate = true

                        for i, waypoint in pairs(waypoints) do
                            repeat
                                clientHumanoid:MoveTo(waypoint.Position)
                            until
                                clientHumanoid.MoveToFinished:Wait()
                        end

                        onGoingLocate = false
                    end)()
                    
                    return "Attempting To Locate!"
                end
                
                return "Error [No Root/Humanoid Found]"
            end
            
            return "Error [No Player Found]"
        end
    )

	command.new(
		{
			"teleport",
			"tp",
			"goto",
			"to"
		}, 
        function(targetName)
            local target = getPlayerFromPartialUsername(targetName)

            if targetName == "$random" then
                local playersIngame = players:GetPlayers()
                local randomIndex = math.random(1, #playersIngame)
                local randomPlayer = playersIngame[randomIndex]

                target = randomPlayer
            end
            
            if target then
                local clientCharacter = client.Character
                local targetCharacter = target.Character
                
                local clientRoot = clientCharacter:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if clientRoot and targetRoot then
                    clientRoot.CFrame = targetRoot.CFrame
                    
                    return "Teleported to target!"
                end
                
                return "Error [No Root Found]"
            end
            
            return "Error [No Player Found]"
        end
	)
end
