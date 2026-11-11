-- Inserta \clearpage antes de cada encabezado de nivel 2 (excepto el primero).
-- Así cada sección ## empieza en una hoja nueva.

local first = true

function Header(el)
  if el.level == 2 then
    if first then
      first = false
      return el
    else
      return {
        pandoc.RawBlock("latex", "\\clearpage"),
        el
      }
    end
  end
  return el
end
