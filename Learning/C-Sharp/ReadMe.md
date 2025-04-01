## Use Case: Create a directory if not exits

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
