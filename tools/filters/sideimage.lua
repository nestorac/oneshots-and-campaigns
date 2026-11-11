-- sideimage.lua
-- Convierte imágenes Markdown con clase .side, .side-r o .side-l
-- en entornos wrapfigure para que el texto fluya al lado.
-- Uso: ![alt](img/archivo.jpg){.side}   o   {.side-r} / {.side-l}
-- La imagen debe ir sola en su párrafo.

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

function Para(el)
  -- Solo actuar si el párrafo contiene exactamente una imagen con clase side
  if #el.content ~= 1 or el.content[1].t ~= "Image" then
    return nil
  end

  local img = el.content[1]
  local side = get_side(img.classes)
  if not side then
    return nil
  end

  local width = img.attributes.width or "0.32\\textwidth"
  width = width:gsub("%%", "\\textwidth")

  local latex = string.format(
    "\\begin{wrapfigure}{%s}{%s}\n" ..
    "\\centering\n" ..
    "\\includegraphics[width=%s]{%s}\n" ..
    "\\end{wrapfigure}\n",
    side,
    width,
    width,
    img.src
  )

  -- Devolver un bloque raw en lugar del párrafo: evita que Pandoc lo convierta en figure
  return pandoc.RawBlock("latex", latex)
end
