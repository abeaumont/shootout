module:    objinst
synopsis:  implemenation of "Object Instantiation" benchmark from http://shootout.alioth.debian.org
author:    Peter Hinely
copyright: public domain


define sealed domain make (singleton(<toggle>));
define sealed domain initialize (<toggle>);


define class <toggle> (<object>)
  slot value :: <boolean>, required-init-keyword: start-state:;
end;


define class <nth-toggle> (<toggle>)
  slot counter :: <integer> = 0;
  slot counter-maxiumum :: <integer>, required-init-keyword: counter-maxiumum:;
end;


define method activate (t :: <toggle>) => ();
  t.value := ~t.value;
end;


define method activate (t :: <nth-toggle>) => ();
  t.counter := t.counter + 1;
  if (t.counter >= t.counter-maxiumum)
    t.value := ~t.value;
    t.counter := 0;
  end;
end;

    
define function main ()
  let arg = string-to-integer(element(application-arguments(), 0, default: "1"));

  let toggle = make(<toggle>, start-state: #t);

  for (i from 1 to 5)
    activate(toggle);
    format-out("%s\n", if (toggle.value) "true" else "false" end);
  end;

  for (i from 1 to arg)
	  let toggle2 = make(<toggle>, start-state: #t);
  end;

  format-out("\n");

  let nth-toggle = make(<nth-toggle>, start-state: #t, counter-maxiumum: 3);

  for (i from 1 to 8)
    activate(nth-toggle);
    format-out("%s\n", if (nth-toggle.value) "true" else "false" end);
  end;

  for (i from 1 to arg)
    let nth-toggle2 = make(<nth-toggle>, start-state: #t, counter-maxiumum: 3);
  end;
end function main;


begin
  main();
end
