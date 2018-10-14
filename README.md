## vis-filetype-settings (move-events branch)

This plugin provides a declarative interface for setting vis
options depending on filetype.

It expects a global variable called `settings` to be defined:

```lua
settings = {
    markdown = {"set expandtab on", "set tabwidth 4"}
}
```

In this variable, filetypes are mapped to sets of settings that are
to be executed when a window containing the specified filetype is
opened.

If you want to do more than setting simple options, you can specify a function instead:

```lua
settings = {
    bash = function(win)
        -- do things for shell scripts
    end
}
```

### More events

By default, all settings are run on the WIN_OPEN event, but if you
want, you can specify your own event.

For more information about these events, check out the [documentation
for the Lua API][doc].  Below is a description of which events are
supported by this plugin.

[doc]: http://martanne.github.io/vis/doc/index.html#events

#### File events

- FILE_OPEN
- FILE_CLOSE
- FILE_SAVE_POST
- FILE_SAVE_PRE

```lua
settings = {
    go = {"set et off", "set tw 8", FILE_SAVE_PRE = "gofmt"}
}
```

This will execute the vis command `gofmt` when Go files are saved.

**WARNING: The command will run in the current window, regardless
of whether it contains a Go file**.

### Window events

- WIN_CLOSE
- WIN_HIGHLIGHT
- WIN_OPEN
- WIN_STATUS

WIN_OPEN is the default event.

### Other events

- INPUT

**WARNING: If you run a vis command on INPUT, vis will automatically
return to normal mode.**  There is currently no workaround, as far
as I am aware.

### Installation

As a suggestion, copy `vis-filetype-settings.lua` into
`~/.config/vis/plugins/` and add the following to your `visrc.lua`:

```lua
require("plugins/vis-filetype-settings")

settings = {
    filetype = settings
}
```
