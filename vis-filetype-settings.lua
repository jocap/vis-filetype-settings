-- vis-filetype-settings
-- (https://github.com/jocap/vis-filetype-settings)

local settings = {}

function execute(s, arg, arg2)
	if type(s) == "table" then
		for key, setting in pairs(s) do
			if type(key) == "number" then -- ignore EVENT keys
				vis:command(setting)
			end
		end
	elseif type(s) == "function" then
		if arg2 then
			s(arg, arg2)
		else
			s(arg)
		end
	end
end

-- Register events

vis.events.subscribe(vis.events.INPUT, function()
	if settings[vis.win.syntax] and settings[vis.win.syntax].INPUT then
		execute(settings[vis.win.syntax].INPUT, nil)
	end
end)

local file_events = {
	"FILE_OPEN",
	"FILE_CLOSE",
	"FILE_SAVE_POST",
	"FILE_SAVE_PRE"
}

for _, event in pairs(file_events) do
	vis.events.subscribe(vis.events[event], function(file, path)
		for win in vis:windows() do
			if win.file == file then
				if settings[win.syntax] and settings[win.syntax][event] then
					execute(settings[win.syntax][event], file, path)
				end
			end
		end
	end)
end

local win_events = {
	"WIN_CLOSE",
	"WIN_HIGHLIGHT",
	"WIN_OPEN",
	"WIN_STATUS"
}

for _, event in pairs(win_events) do
	vis.events.subscribe(vis.events[event], function(win)
                if settings[win.syntax] == nil then return end
		if settings[win.syntax] then
			if settings[win.syntax][event] then
				execute(settings[win.syntax][event], win)
			elseif event == "WIN_OPEN" then -- default event
				execute(settings[win.syntax], win)
			end
		end
	end)
end
