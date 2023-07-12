

3.cubed;
//local v. global
//local variables must be declared before being used

//global variables persist (a-z or ~)
//environment variables

(
var number; //local variable must be declared ad
number = 3.cubed;
)


(
var foo;
foo = 3;
foo = foo.cubed;
foo = foo + 100;
foo = foo / 2;
foo;
)

//no operator precedence
//global variables can be declared and executed in the same line

~foo = 3.cubed + 100 / 2; 