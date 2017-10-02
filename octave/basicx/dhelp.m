function dhelp(x)
% DHELP - Basic HELP function without extra junk
%   DHELP TOPIC shows help about TOPIC.

if nargin==0
  help;
else
  [text, format] = get_help_text(x);

  switch (lower (format))
    case "plain text"
      status = 0;
    case "texinfo"
      [text, status] = __makeinfo__ (text, "plain text");
    case "html"
      [text, status] = strip_html_tags (text);
    case "not documented"
      error ("help: `%s' is not documented\n", name);
    case "not found"
      do_contents (name);
      return;
    otherwise
      error ("help: internal error: unsupported help text format: '%s'\n", format);
  end

  if status==0
    printf("%s\n", text);
  else
    warning ("help: Texinfo formatting filter exited abnormally.\n");
  end
end
  