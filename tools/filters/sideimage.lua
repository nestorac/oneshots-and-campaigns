-- sideimage.lua
-- Convierte imágenes Markdown con clase .side, .side-r o .side-l
-- en entornos wrapfigure para que el texto fluya al lado.
-- Uso: ![alt](img/archivo.jpg){.side}   o   {.side-r} / {.side-l}

local function get_side(classes)
  for _, c in ipairs(classes) do
    if c == "side-l" or c == "side" then
      return "l"
    elseif c == "side-r" then
      return "r"
    end
  end
  return nil
end

function Image(el)
  local side = get_side(el.classes)
  if not side then
    return nil -- no tocar imágenes normales
  end

  local width = el.attributes.width or "0.32\\textwidth"
  -- limpiar unidades si el usuario puso width=32% o similar
  width = width:gsub("%%", "\\textwidth")

  local latex = string.format(
    "\\begin{wrapfigure}{%s}{%s}\n" ..
    "\\centering\n" ..
    "\\includegraphics[width=%s]{%s}\n" ..
    "\\end{wrapfigure}\n",
    side,
    width,
    width,
    el.src
  )

  return pandoc.RawInline("latex", latex)
end
