-- vis-filetype-settings
-- (https://github.com/jocap/vis-filetype-settings)

local M = {}

M.settings = {}

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
	if M.settings[vis.win.syntax] and M.settings[vis.win.syntax].INPUT then
		execute(M.settings[vis.win.syntax].INPUT, nil)
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
				if M.settings[win.syntax] and M.settings[win.syntax][event] then
					execute(M.settings[win.syntax][event], file, path)
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
                if M.settings[win.syntax] == nil then return end
		if M.settings[win.syntax] then
			if M.settings[win.syntax][event] then
				execute(M.settings[win.syntax][event], win)
			elseif event == "WIN_OPEN" then -- default event
				execute(M.settings[win.syntax], win)
			end
		end
	end)
end

return M
