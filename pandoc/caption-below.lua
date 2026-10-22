-- Move table captions below their tables in LaTeX/PDF output.
--
-- Pandoc's LaTeX writer always places a table caption at the top.  This
-- filter strips the caption from the table and re-emits it immediately
-- after the table with \captionof (from the caption package, loaded in the
-- header written by render.bash), so numbering ("Table 1:") is unchanged.
--
-- Spacing: longtable normally adds \LTpost (a \bigskip) after the table.
-- For captioned tables that space is removed (inside a group, so tables
-- without captions are unaffected), the caption package's skip puts a small
-- gap between table and caption, and a \bigskip follows the caption instead.
--
-- Numbering: longtable steps the table counter itself, even without a
-- caption, so the counter is stepped back once before \captionof steps it
-- again; otherwise the first table would be numbered "Table 2".

function Table(tbl)
  if not FORMAT:match('latex') then
    return nil
  end
  local blocks = tbl.caption.long
  if #blocks == 0 then
    return nil
  end
  local text = pandoc.write(pandoc.Pandoc(blocks), 'latex'):gsub('%s+$', '')
  tbl.caption = { long = {}, short = nil }
  return {
    pandoc.RawBlock('latex', '\\begingroup\\setlength{\\LTpost}{0pt}'),
    tbl,
    pandoc.RawBlock('latex', '\\addtocounter{table}{-1}\\captionof{table}{' .. text
      .. '}\n\\endgroup\\bigskip'),
  }
end
