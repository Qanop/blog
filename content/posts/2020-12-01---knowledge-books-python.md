---
title: "Knowledge books: Python"
date: "2020-12-01T00:39:21.000Z"
template: "post"
draft: false
slug: "knowledge-books-python"
category: "Technology"
tags:
- "Technology"
- "Knowledge books"
- "Dev"
description: "A list of useful topics related to the language, its functionality and small snippets. Everything that may be useful now or in the future"
socialImage: "media/server-7.jpg"
---
_**Knowledge books** is a mini series of constantly updated articles in which I share my more interesting discoveries_

Each language has its own nice extras. The same applies to the functions and usability of the basic functions of the programs. Of course, the important thing is that if some parts are not used on a daily basis, they may be forgotten. Therefore, here are some brief notes on this language functions and methods of implantation. Written knowledge cannot be forgotten.

![Knowledge books: Python](/media/server-7.jpg)

Table of Contents:
- [Array operations](#array-operations)
- [Code improvements](#code-improvements)
- [Command line arguments](#command-line-arguments)
- [Decorators](#decorators)
- [Docstring](#docstring)
- [Functions](#functions)
    - [Mutable Default Parameter Values](#mutable-default-parameter-values)
    - [Mutable Objects](#mutable-objects)
    - [Args](#args)
    - [Argument Tuple Unpacking](#argument-tuple-unpacking)
    - [Argument Dictionary Packing](#argument-dictionary-packing)
    - [Keyword-Only Any Arguments](#keyword-only-any-arguments)
    - [Keyword-Only No Additional Arguments](#keyword-only-no-additional-arguments)
    - [Python Function Annotations](#python-function-annotations)
- [Magic attributes](#magic-attributes)
- [Loops & Enumerate](#loops--enumerate)
    - [Content loop](#content-loop)
    - [Content loop with manual index](#content-loop-with-manual-index)
    - [Range loop](#range-loop)
    - [Enumerate loop](#enumerate-loop)
    - [Enumerate example usage](#enumerate-example-usage)
    - [Array strip examples](#array-strip-examples)
    - [Using iterator in enumerate](#using-iterator-in-enumerate)
- [Object-oriented programming](#object-oriented-programming-oop)
- [Other topics](#other-topics)
- [Opening file streams](#opening-file-streams)
- [Practice materials](#practice-materials)
- [References](#references)
- [Return statements & generators](#return-statements--generators)
- [String formatting](#string-formatting)
    - [Old Style” String Formatting (% Operator)](#old-style-string-formatting--operator)
    - [“New Style” String Formatting (str.format)](#new-style-string-formatting-strformat)
    - [String Interpolation / f-Strings (Python 3.6+)](#string-interpolation--f-strings-python-36)
    - [Template Strings (Standard Library)](#template-strings-standard-library)
- [Testing](#testing)
- [Threading](#threading)


# Array operations
- [Python's map(): Processing Iterables Without a Loop](https://realpython.com/python-map-function/)
- [Python's reduce(): From Functional to Pythonic Style](https://realpython.com/python-reduce-function/)

# Code improvements
- [Python Code Quality: Tools & Best Practices](https://realpython.com/python-code-quality/)
- [Documenting Python Code: A Complete Guide](https://realpython.com/documenting-python-code/)
- [Python Application Layouts: A Reference](https://realpython.com/python-application-layouts/)
- [Python Logging: A Stroll Through the Source Code](https://realpython.com/python-logging-source-code/)
- [Refactoring Python Applications for Simplicity](https://realpython.com/python-refactoring/)
- [How to Write Beautiful Python Code With PEP 8](https://realpython.com/python-pep8/)
- [The Most Diabolical Python Antipattern](https://realpython.com/the-most-diabolical-python-antipattern/)

# Command line arguments
- [Python Command Line Arguments](https://realpython.com/python-command-line-arguments/)

# Decorators
- [Primer on Python Decorators](https://realpython.com/primer-on-python-decorators/)

# Docstring
- [Example NumPy Style Python Docstrings](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html#example-numpy)

# Functions
- [Defining Your Own Python Function](https://realpython.com/defining-your-own-python-function/)
- [How to Use Python Lambda Functions](https://realpython.com/python-lambda/)

#### Mutable Default Parameter Values
In Python, default parameter values are defined only once when the function is defined (that is, when the def statement is executed). The default value isn't re-defined each time the function is called. Thus, each time you call f() without a parameter, you're performing .append() on the same list.

```python
def f(my_list = []):
    my_list.append('###')
    return my_list

f()
# ['###']
f()
# ['###', '###']
```

As a workaround, consider using a default argument value that signals no argument has been specified. Most any value would work, but None is a common choice.

```python
def f(my_list=None):
    if my_list is None:
        my_list = []
        my_list.append('###')
    return my_list
```

#### Mutable Objects
Argument passing in Python can be summarized as follows. **Passing an immutable object**, like an int, str, tuple, or frozenset, to a Python function acts like pass-by-value. The function can't modify the object in the calling environment.

**Passing a mutable object** such as a list, dict, or set acts somewhat—but not exactly—like pass-by-reference. The function can't reassign the object wholesale, but it can change items in place within the object, and these changes will be reflected in the calling environment.

#### Args
```python
def f(*args):
    print(args)
    print(type(args), len(args))
    for x in args:
            print(x)


f(1, 2, 3)
# (1, 2, 3)        
# <class 'tuple'> 3
# 1
# 2
# 3
```

#### Argument Tuple Unpacking
Although this type of unpacking is called tuple unpacking, it doesn't only work with tuples. The asterisk (*) operator can be applied to any iterable in a Python function call. For example, a list or set can be unpacked as well

```python
def f(x, y, z):
    print(f'x = {x}')
    print(f'y = {y}')
    print(f'z = {z}')

f(1, 2, 3)
# x = 1
# y = 2
# z = 3

t = ('foo', 'bar', 'baz')
f(*t)
# x = foo
# y = bar
# z = baz
```

#### Argument Dictionary Packing
```python
def f(**kwargs):
    print(kwargs)
    print(type(kwargs))
    for key, val in kwargs.items():
            print(key, '->', val)


f(foo=1, bar=2, baz=3)
# {'foo': 1, 'bar': 2, 'baz': 3}
# <class 'dict'>
# foo -> 1
# bar -> 2
# baz -> 3
```

#### Keyword-Only Any Arguments
```python
def oper(x, y, *ignore, op='+'):
    if op == '+':
            return x + y
    elif op == '-':
            return x - y
    elif op == '/':
            return x / y
    else:
            return None


oper(3, 4, op='+')
# 7
oper(3, 4, op='/')
# 0.75
oper(3, 4, "I don't belong here")
# 7
oper(3, 4, "I don't belong here", op='/')
# 0.75
```

#### Keyword-Only No Additional Arguments
```python
def oper(x, y, *, op='+'):
    if op == '+':
            return x + y
    elif op == '-':
            return x - y
    elif op == '/':
            return x / y
    else:
            return None


oper(3, 4, op='+')
# 7
oper(3, 4, op='/')
# 0.75

oper(3, 4, "I don't belong here")
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# TypeError: oper() takes 2 positional arguments but 3 were given

oper(3, 4, '+')
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# TypeError: oper() takes 2 positional arguments but 3 were given
```

#### Python Function Annotations
Annotations don't impose any semantic restrictions on the code whatsoever. They're simply bits of metadata attached to the Python function parameters and return value. Python dutifully stashes them in a dictionary, assigns the dictionary to the function's `__annotations__` dunder attribute, and that's it. Annotations are completely optional and don't have any impact on Python function execution at all.

To quote Amahl in Amahl and the Night Visitors, “What's the use of having it then?”

For starters, annotations make good documentation. You can specify the same information in the docstring, of course, but placing it directly in the function definition adds clarity. 
```python
def f(a: int = 12, b: str = 'baz') -> float:
    print(a, b)
    return 3.5

f.__annotations__
# {'a': <class 'int'>, 'b': <class 'str'>, 'return': <class 'float'>}
```

# Magic attributes
- [A Guide to Python's Magic Methods](https://rszalski.github.io/magicmethods/)
- [How to Call Magic Methods](https://rszalski.github.io/magicmethods/#appendix1)

Magic Methods:
- Construction and Initialization
    - `__init__(self, [...)` The initializer for the class. It gets passed whatever the primary constructor was called with
    - `__new__(cls, [...)` Is the first method to get called in an object's instantiation. It takes the class, then any other arguments that it will pass along to `__init__`. `__new__` is used fairly rarely, but it does have its purposes, particularly when subclassing an immutable type like a tuple or a string.
    - `__del__(self)`  It defines behavior for when an object is garbage collected. It can be quite useful for objects that might require extra cleanup upon deletion, like sockets or file objects.
- Comparison magic methods
    - `__cmp__(self, other)` Is the most basic of the comparison magic methods. It actually implements behavior for all of the comparison operators (<, ==, !=, etc.). Should return a negative integer if self < other, zero if self == other, and positive if self > other
    - `__eq__(self, other)` Behavior: equality operator, `==`
    - `__nq__(self, other)` Behavior: inequality operator, `!=`
    - `__lt__(self, other)` Behavior: less-than operator, `<`
    - `__gt__(self, other)` Behavior: greater-than operator, `>`
    - `__le__(self, other)` Behavior: less-than-or-equal-to operator, `<=`
    - `__ge__(self, other)` Behavior: greater-than-or-equal-to operator, `>=`
- Numeric magic methods
    - Unary operators and functions
    - Normal arithmetic operators
    - Reflected arithmetic operators `some_object + other` That was "normal" addition. The reflected equivalent is the same thing, except with the operands switched around: `other + some_object`
    - Augmented assignment
    - Type conversion magic methods
- Representing your Classes
    - `__str__(self)` Defines behavior for when str() is called on an instance of your class.
    - `__repr__(self)` The major difference between str() and repr() is intended audience. repr() is intended to produce output that is mostly machine-readable (in many cases, it could be valid Python code even), whereas str() is intended to be human-readable.
    - `__hash__(self)` 
- Controlling Attribute Access
    - `__getattr__(self, name)`
    - `__setattr__(self, name, value)`
    - `__delattr__(self, name)`
- Making Custom Sequences
    - The magic behind containers
- Reflection
- Callable Objects
    - `__call__(self, [args...])` Allows an instance of a class to be called as a function. Essentially, this means that x() is the same as `x.__call__()`
- Context Managers
    - `__enter__(self)` Defines what the context manager should do at the beginning of the block created by the with statement. Note that the return value of __enter__ is bound to the target of the with statement, or the name after the as.
    - `__exit__(self, exception_type, exception_value, traceback)`
- Building Descriptor Objects
    - `__get__(self, instance, owner)` Define behavior for when the descriptor's value is retrieved. instance is the instance of the owner object. owner is the owner class itself.
    - `__set__(self, instance, value)`
    - `__delete__(self, instance)`
- Copying
    - `__copy__(self)`
    - `__deepcopy__(self, memodict={})`
- Other
    - `__annotations__(self)`
    - `__doc__(self)`

# Loops & Enumerate
- [Python enumerate(): Simplify Looping With Counters](https://realpython.com/python-enumerate/)

&check; Use Python's enumerate() in your for loops\
&check; Get values from enumerate() using argument unpacking\
&check; Implement your own equivalent function to enumerate()\

_Technical Detail: According to the Python documentation, an iterable is any object that can return its members one at a time. By definition, iterables support the iterator protocol, which specifies how object members are returned when an object is used in an iterator. Python has two commonly used types of iterables:_
- [_Sequences_](https://docs.python.org/3/glossary.html#term-sequence)
- [_Generators_](https://docs.python.org/3/glossary.html#term-generator)

#### Content loop
```python
values = ["a", "b", "c"]
for value in values:
    print(value)
# a
# b
# c
```

#### Content loop with manual index
```python
index = 0
values = ["a", "b", "c"]
for value in values:
    print(index, value)
    index += 1
# 0 a
# 1 b
# 2 c
```

#### Range loop
```python
values = ["a", "b", "c"]
for index in range(len(values)):
    value = values[index]
    print(index, value)
```

You should use enumerate() anytime you need to use the count and an item in a loop. Keep in mind that enumerate() increments the count by one on every iteration. 

#### Enumerate loop
```python
values = ["a", "b", "c"]
for count, value in enumerate(values, start=0):
    print(count, value)
```

#### Enumerate example usage
```python
def even_items(iterable):
    """Return items from ``iterable`` when their index is even."""
    values = []
    for index, value in enumerate(iterable, start=1):
        if not index % 2:
            values.append(value)
    return values
```

#### Array strip examples
```python
def even_items(iterable):
    return [v for i, v in enumerate(iterable, start=1) if not i % 2]

alphabet = "abcdefghijklmnopqrstuvwxyz"
even_items(alphabet)
# ['b', 'd', 'f', 'h', 'j', 'l', 'n', 'p', 'r', 't', 'v', 'x', 'z']
list(alphabet[1::2])
# ['b', 'd', 'f', 'h', 'j', 'l', 'n', 'p', 'r', 't', 'v', 'x', 'z']
```

#### Using iterator in enumerate
```python
def alphabet():
    alpha = "abcdefghijklmnopqrstuvwxyz"
    for a in alpha:
        yield a

alphabet[1::2]
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# TypeError: 'function' object is not subscriptable

even_items(alphabet())
# ['b', 'd', 'f', 'h', 'j', 'l', 'n', 'p', 'r', 't', 'v', 'x', 'z']
```

When you call enumerate() and pass a sequence of values, Python returns an iterator. When you ask the iterator for its next value, it yields a tuple with two elements. The first element of the tuple is the count, and the second element is the value from the sequence that you passed:

```python
values = ["a", "b"]
enum_instance = enumerate(values)
enum_instance
# <enumerate at 0x7fe75d728180>
next(enum_instance)
# (0, 'a')
next(enum_instance)
# (1, 'b')
next(enum_instance)
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# StopIteration
```

In the for loop in this example, you nest zip() inside enumerate(). This means that each time the for loop iterates, enumerate() yields a tuple with the first value as the count and the second value as another tuple containing the elements from the arguments to zip(). To unpack the nested structure, you need to add parentheses to capture the elements from the nested tuple of elements from zip().

```python
first = ["a", "b", "c"]
second = ["d", "e", "f"]
third = ["g", "h", "i"]
for one, two, three in zip(first, second, third):
    print(one, two, three)

# a d g
# b e h
# c f i

for count, (one, two, three) in enumerate(zip(first, second, third)):
    print(count, one, two, three)

# 0 a d g
# 1 b e h
# 2 c f i
```

# Object-oriented programming (OOP)
- [Python '!=' Is Not 'is not': Comparing Objects in Python](https://realpython.com/python-is-identity-vs-equality/)
- [Inheritance and Composition: A Python OOP Guide](https://realpython.com/inheritance-composition-python/)
- [Supercharge Your Classes With Python super()](https://realpython.com/python-super/)
- [The Factory Method Pattern and Its Implementation in Python](https://realpython.com/factory-method-python/)

# Other topics
- [Absolute vs Relative Imports in Python](https://realpython.com/absolute-vs-relative-python-imports/)
- [Python Virtual Environments: A Primer](https://realpython.com/python-virtual-environments-a-primer/)
- [Defining Main Functions in Python](https://realpython.com/python-main-function/)
- [Continuous Integration With Python: An Introduction](https://realpython.com/python-continuous-integration/)

# Opening file streams
- [What is the python “with” statement designed for?](https://stackoverflow.com/questions/3012488/what-is-the-python-with-statement-designed-for)

# Practice materials
- [Python Practice Problems: Get Ready for Your Next Interview](https://realpython.com/python-practice-problems/)
- [How to Stand Out in a Python Coding Interview](https://realpython.com/python-coding-interview-tips/)

# References
- [Pass by Reference in Python: Background and Best Practices](https://realpython.com/python-pass-by-reference/)

# Return statements & generators
- [The Python return Statement: Usage and Best Practices](https://realpython.com/python-return-statement/)

# String formatting
- [Python String Formatting Best Practices](https://realpython.com/python-string-formatting/)

#### Old Style” String Formatting (% Operator)
```python
'Hello, %s' % name
# "Hello, Bob"

'Hey %s, there is a 0x%x error!' % (name, errno)
# 'Hey Bob, there is a 0xbadc0ffee error!'

'Hey %(name)s, there is a 0x%(errno)x error!' % { "name": name, "errno": errno }
# 'Hey Bob, there is a 0xbadc0ffee error!'
```
This makes your format strings easier to maintain and easier to modify in the future. You don't have to worry about making sure the order you're passing in the values matches up with the order in which the values are referenced in the format string. Of course, the downside is that this technique requires a little more typing.

#### “New Style” String Formatting (str.format)
```python
'Hello, {}'.format(name)
# 'Hello, Bob'

'Hey {name}, there is a 0x{errno:x} error!'.format(name=name, errno=errno)
# 'Hey Bob, there is a 0xbadc0ffee error!'
```

This also shows that the syntax to format an int variable as a hexadecimal string has changed. Now you need to pass a format spec by adding a :x suffix. The format string syntax has become more powerful without complicating the simpler use cases.

#### String Interpolation / f-Strings (Python 3.6+)
```python
f'Hello, {name}!'
# 'Hello, Bob!'

f'Five plus ten is {a + b} and not {2 * (a + b)}.'
# 'Five plus ten is 15 and not 30.'

f"Hey {name}, there's a {errno:#x} error!"
# "Hey Bob, there's a 0xbadc0ffee error!"
```

#### Template Strings (Standard Library)
```python
from string import Template
t = Template('Hey, $name!')
t.substitute(name=name)
# 'Hey, Bob!'

templ_string = 'Hey $name, there is a $error error!'
Template(templ_string).substitute(name=name, error=hex(errno))
# 'Hey Bob, there is a 0xbadc0ffee error!'

user_input = '${error.__init__.__globals__[SECRET]}'
Template(user_input).substitute(error=err)
# ValueError:
# "Invalid placeholder in string: line 1, col 1"
```

# Testing
- [Getting Started With Testing in Python](https://realpython.com/python-testing/)
- [4 Techniques for Testing Python Command-Line (CLI) Apps](https://realpython.com/python-cli-testing/)

# Threading
- [An Intro to Threading in Python](https://realpython.com/intro-to-python-threading/)
- [Speed Up Your Python Program With Concurrency](https://realpython.com/python-concurrency/)