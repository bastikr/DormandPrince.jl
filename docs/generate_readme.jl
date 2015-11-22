using DormandPrince45

sourcepath = "README.in.rst"
targetpath = "../README.rst"

f = open(sourcepath)
buf = readall(f)
close(f)

function find_matchingbracket(buf, i0)
    N = length(buf)
    count = 1
    for i=i0+1:N
        if buf[i] == '('
            count += 1
        elseif buf[i] == ')'
            count -= 1
        end
        if count == 0
            return i
        end
    end
    return nothing
end


function render_function(arg)
    r = search(arg, "::")
    src = "../" * arg[1:first(r)-1]
    name = arg[last(r)+1:end]

    f = open(src)
    buf = readall(f)
    close(f)

    # extract docstring
    regex = Regex("function $(name)[\{\[]")
    r = match(regex, buf)
    i1 = rsearchindex(buf, "\"\"\"", r.offset) - 2
    i0 = rsearchindex(buf, "\"\"\"", i1) + 4
    docstring = buf[i0:i1]

    # extract function definition
    i0 = searchindex(buf, "(", r.offset)
    i1 = find_matchingbracket(buf, i0)
    funcstring = buf[r.offset:i1]

    return ".. code-block:: julia\n\n    " * funcstring * "\n\n" * docstring
end


function render(cmd)
    i0 = length(".. expand ") + 1
    i1 = searchindex(cmd, " ", i0)
    directive = cmd[i0:i1-1]
    arg = cmd[i1+1:end]
    if directive == "function"
        text = render_function(arg)
    end
    return text
end

text = replace(buf, r"\.\. expand .*", render)
f = open(targetpath, "w")
write(f, text)
close(f)


