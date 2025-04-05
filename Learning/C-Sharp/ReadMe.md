## Learning number 1 : We don't require _**.Exists**_ condition and the reason is this functionality checks in by default of _**.CreateDirectory**_ method.


### Option 1
~~~
if(!Directory.Exists("C:\Temp\CSharp"))
{
   Directory.CreateDirectory("C:\Temp\CSharp");
}
~~~

### Option 2: Simplest one - If directory is exists then it won't create or throw. If not then create it.
~~~
  Directory.CreateDirectory("C:\Temp\CSharp");
~~~
