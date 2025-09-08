Help us add in support for exporting themes, this will be
avalible through the API, allowing for user so to output the 
able to configure multiple aspect of how the theme will be
exported

the basic usage will look like 

require('xeno').export({
  format = "lua" -- or vim
  output = "" -- optional ouput directory. `.config/nvim/colors/xeno/` by default
})

This file will structure the current theme into a nice file where
all of the highlights are organized nicely, using DRY priniples

We utilize a template file for both lua, and vim which will
then be propigated by the current highlights for the theme.

Note that anytime the export theme is called, if a xeno theme is
loaded, we'll then export that theme

Organize the base, accent, and any custom colors in the 
template file in a way which would make sense, allowing users to
use this exported file as a theme its self, even if the xeno
plugin isn't installed. 

Let's determine the technical feasibility of this. and what the
best approach would be in order to implement this

