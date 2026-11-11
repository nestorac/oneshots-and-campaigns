-- sideimage.lua
-- Fuerza imágenes con .side / .side-r / .side-l al lado del texto usando minipages.
-- Sustituye completamente el párrafo de la imagen para evitar que Pandoc genere figuras.

local function get_side(classes)
  for _, c in ipairs(classes or {}) do
    if c == "side-l" or c == "side" then return "l"
    elseif c == "side-r" then return "r"
    end
  end
  return nil
end

local pending_img = nil

function Para(el)
  -- Si hay una imagen pendiente, emparejarla con este párrafo de texto
  if pending_img then
    local img = pending_img
    pending_img = nil

    local side = img.side
    local src  = img.src
    local w    = img.width

    local text_latex = pandoc.write(pandoc.Pandoc({el}), "latex")
    text_latex = text_latex:gsub("^%s+", ""):gsub("%s+$", "")

    local latex
    if side == "r" then
      latex = string.format(
        "\\noindent\\begin{minipage}[t]{0.62\\textwidth}\n%s\n\\end{minipage}\\hfill\n" ..
        "\\begin{minipage}[t]{%s}\n\\centering\\includegraphics[width=%s]{%s}\n\\end{minipage}\n\\vspace{0.5em}\n",
        text_latex, w, w, src
      )
    else
      latex = string.format(
        "\\noindent\\begin{minipage}[t]{%s}\n\\centering\\includegraphics[width=%s]{%s}\n\\end{minipage}\\hfill\n" ..
        "\\begin{minipage}[t]{0.62\\textwidth}\n%s\n\\end{minipage}\n\\vspace{0.5em}\n",
        w, w, src, text_latex
      )
    end

    return pandoc.RawBlock("latex", latex)
  end

  -- Detectar párrafo que es solo una imagen lateral y marcarlo como pendiente
  if #el.content == 1 and el.content[1].t == "Image" then
    local img = el.content[1]
    local side = get_side(img.classes)
    if side then
      local width = img.attributes.width or "0.30\\textwidth"
      width = width:gsub("%%", "\\textwidth")
      pending_img = {
        side = side,
        src = img.src,
        width = width
      }
      -- Consumir el párrafo de la imagen por completo (no devolver nada)
      return {}
    end
  end

  return nil
end

-- Por si acaso, también interceptar Image sueltas
function Image(el)
  local side = get_side(el.classes)
  if side then
    -- Si llega aquí, devolver un includegraphics crudo para evitar figure
    local width = el.attributes.width or "0.30\\textwidth"
    width = width:gsub("%%", "\\textwidth")
    return pandoc.RawInline("latex",
      string.format("\\includegraphics[width=%s]{%s}", width, el.src))
  end
  return nil
end
