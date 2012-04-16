trigger HelloWorldAccountTrigger on Account (before insert)
{
    Account[] acc=Trigger.New;
    
    HelloWorld.addHelloWorld(acc);
}