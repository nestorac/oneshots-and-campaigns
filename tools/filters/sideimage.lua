-- sideimage.lua
-- Coloca imágenes con clase .side / .side-r / .side-l al lado del texto
-- usando minipages (más fiable que wrapfig con la salida de Pandoc).
-- Uso: ![alt](img/archivo.jpg){.side-r width=0.32\textwidth}
-- La imagen debe ir sola en su párrafo, seguida del texto que debe ir a su lado.

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

-- Acumula el texto que sigue a una imagen lateral
local pending = nil

function Para(el)
  -- Si hay una imagen lateral pendiente, este párrafo va en el minipage de texto
  if pending then
    local img = pending.img
    local side = pending.side
    local width = pending.width
    pending = nil

    local text_width = "0.62\\textwidth"
    local img_width  = width

    local latex
    if side == "r" then
      latex = string.format(
        "\\noindent\\begin{minipage}[t]{%s}\n%%\n",
        text_width
      )
      -- el texto de este párrafo se añade después
    else
      latex = string.format(
        "\\noindent\\begin{minipage}[t]{%s}\n\\centering\\includegraphics[width=%s]{%s}\n\\end{minipage}\\hfill\n\\begin{minipage}[t]{%s}\n%%\n",
        img_width, img_width, img.src, text_width
      )
    end

    -- Convertir el párrafo actual a LaTeX y añadirlo
    local text_latex = pandoc.write(pandoc.Pandoc({el}), "latex")
    text_latex = text_latex:gsub("^%s+", ""):gsub("%s+$", "")

    if side == "r" then
      latex = latex .. text_latex .. "\n\\end{minipage}\\hfill\n" ..
              string.format("\\begin{minipage}[t]{%s}\n\\centering\\includegraphics[width=%s]{%s}\n\\end{minipage}\n\\vspace{0.6em}\n",
                img_width, img_width, img.src)
    else
      latex = latex .. text_latex .. "\n\\end{minipage}\n\\vspace{0.6em}\n"
    end

    return pandoc.RawBlock("latex", latex)
  end

  -- Detectar párrafo que es solo una imagen lateral
  if #el.content == 1 and el.content[1].t == "Image" then
    local img = el.content[1]
    local side = get_side(img.classes)
    if side then
      local width = img.attributes.width or "0.32\\textwidth"
      width = width:gsub("%%", "\\textwidth")
      pending = { img = img, side = side, width = width }
      return {}  -- consumir este párrafo; el siguiente se procesará con la imagen
    end
  end

  return nil
end
