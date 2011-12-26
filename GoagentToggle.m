#import <UIKit/UIKit.h>

#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <notify.h>
#include <sys/types.h>
#include <sys/stat.h>

BOOL isCapable()
{
	return YES;
}

// This runs when iPhone springboard resets. This is on boot or respring.
BOOL isEnabled()
{
	struct stat st;
	if(stat("/tmp/goagent.pid",&st)==0)
	    return TRUE;
	else return FALSE;
}

// This function is optional and should only be used if it is likely for the toggle to become out of sync
// with the state while the iPhone is running. It must be very fast or you will slow down the animated
// showing of the sbsettings window. Imagine 12 slow toggles trying to refresh tate on show.
BOOL getStateFast()
{
	return isEnabled();
}

// Pass in state to set. YES for enable, NO to disable.
void setState(BOOL Enable)
{
	if (Enable == YES) 
	{
		notify_post("com.goagent.enable");
	}
	else if (Enable == NO) 
	{
		notify_post("com.goagent.disable");
	}
}

// Amount of time spinner should spin in seconds after the toggle is selected.
float getDelayTime()
{
	return 0.6f;
}

// Runs when the dylib is loaded. Only useful for debug. Function can be omitted.
__attribute__((constructor)) 
static void toggle_initializer() 
{ 
	NSLog(@"Initializing LServices Toggle\n"); 
}
