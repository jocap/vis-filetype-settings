## vis-autocmd

This plugin provides a declarative interface for setting vis
options depending on filetype.

It expects a global variable called `settings` to be defined:

```lua
settings = {
    markdown = {"expandtab on", "tabwidth 4"}
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

Be sure not to run commands that open another window with the same
filetype, leading to an infinite loop.
