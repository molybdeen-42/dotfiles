-- Curves
hl.curve( "switch", { type = "bezier", points = { {0.31, -0.43}, {0.53, 1.03} } } )
hl.curve( "smooth", { type = "bezier", points = { {0.83, 0.44}, {0.34, 0.87} } } )

-- Animations
hl.animation( { leaf = "workspaces", enabled = true, speed = 7.5, bezier = "switch" } )
hl.animation( { leaf = "windowsMove", enabled = true, speed = 3, bezier = "smooth" } )
hl.animation( { leaf = "windowsIn", enabled = true, speed = 4, bezier = "smooth", style = "popin 10%" } )
hl.animation( { leaf = "windowsOut", enabled = true, speed = 4, bezier = "smooth", style = "popin 10%" } )