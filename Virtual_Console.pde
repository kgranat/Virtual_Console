/***************************************************
 * Virtual Console
 *
 *
 *
 *
 *
 ***************************************************/


import processing.serial.*; //import serial libraries

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
char buttons;  //

int right_V = 128 ;
int right_H = 128;
int left_H = 128;
int left_V = 128;

int doubleJoy_H = 128;
int doubleJoy_V = 128;
int verticalJoy_V = 128;
int [] horizontalJoy_H ={128,128,128};

PImage bg;

int [] buttonState ={0,0,0,0};

int allButtons;



int [][] horizontalJoy = {
{450,115,100,25},
{250,285,100,25},
{450,285,100,25}
};



int [] verticalJoy = {115,250,25,100};
int [] doubleJoy = {250,75,100,100};

float [] joyStickOffset ={0,0};

int [][] buttonCoord = {
{50,50,57,57},
{150,50,57,57},
{50,150,57,57},
{150,150,57,57}
};



int [][] mouseJoystickCoord = { 
{0,0},
{0,0}
};

float [][] mouseJoystickOffset = { 
{0,0},
{0,0}
};





//int joyRightCenter[] ={(buttonCoord[8][0] + buttonCoord[8][2]/2) ,(buttonCoord[8][1] + buttonCoord[8][3]/2)} ;//center of right joystick

void setup() 
{
  print('-');
  println(' ');
  
  size(624, 404);
  bg = loadImage("console.png");
  background(bg);
   
  
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  
 // String portName = Serial.list()[7];
 // String port = "tty.usbserial-A900XOMV"; 
 // String portName = "/dev/cu.usbserial-A900XOMV"; 
 // String portName = "/dev/cu.usbserial-FTT37ZWJ"; 
 // String portName = "/dev/cu.usbserial-FTT37ZWJ"; 
  String portName = "COM5"; 
 
 
  println(Serial.list());

 myPort = new Serial(this, portName, 38400);
}

void draw() {
 
  allButtons = 0;
    
  //check individual buttons, conver them into a byte for the commander protocol  
  for(int i=0;i<4;i++)
  {
    if(buttonState[i] == 1)
    {
      allButtons += pow(2,i);
      println(allButtons);
      buttonState[i] = 0; 
    }
  }
  
  if(mouseOverJoystick(doubleJoy) == true && mousePressed == true)
  {
     joyStickOffset[0] = mouseX - doubleJoy[0];
     joyStickOffset[1] = mouseY - doubleJoy[1];
     //print(joyStickOffset[0]);
     //print('-');
     //println(joyStickOffset[1]);
     
     doubleJoy_H = floor(((joyStickOffset[0]/doubleJoy[2])*255));
     doubleJoy_V = floor(255-((joyStickOffset[1]/doubleJoy[3])*255));
     //print(doubleJoy_H);
     //print('-');
     //println(doubleJoy_V);   
  }
  else
  {
    doubleJoy_H = 128;
    doubleJoy_V = 128;
  }
  
  
  if(mouseOverJoystick(verticalJoy) == true && mousePressed == true)
  {
     joyStickOffset[1] = mouseY - verticalJoy[1];
     //println(joyStickOffset[1]);
     
     verticalJoy_V = floor(255-((joyStickOffset[1]/verticalJoy[2])*255));
     //println(verticalJoy_V);
      
  }
  else
  {
    verticalJoy_V = 128;
  }
  
  
  for(int i=0;i<3;i++)
  {  
    if(mouseOverJoystick(horizontalJoy[i]) == true && mousePressed == true)
    {
      joyStickOffset[1] = mouseX - horizontalJoy[i][0];
      horizontalJoy_H[i] = floor(((joyStickOffset[1]/horizontalJoy[i][2])*255));
      print("x,y");
      print(mouseX);
      print("-");
      println(mouseY);
      
      println(joyStickOffset[1]);
      
      println(horizontalJoy_H[i]);
      
    }
    else
    {
      horizontalJoy_H[i] = 128; 
    }
  }  
 


    
    myPort.write(0xff);
    
    myPort.write((char)horizontalJoy_H[0]);
    myPort.write((char)horizontalJoy_H[1]);
    myPort.write((char)verticalJoy_V);
    myPort.write((char)horizontalJoy_H[2]);
    myPort.write((char)doubleJoy_V);
    myPort.write((char)doubleJoy_H);
    myPort.write(allButtons);
    myPort.write((char)0);
    myPort.write((char)(255 - (horizontalJoy_H[0]+horizontalJoy_H[1]+verticalJoy_V+horizontalJoy_H[2]+doubleJoy_V+doubleJoy_H+allButtons)%256));
    myDelay(5);
}



boolean mouseClickRect(int rectangle[])
{

   return ((mouseX >= rectangle[0]) && (mouseX <= (rectangle[0]+rectangle[2])) && (mouseY >= rectangle[1]) && (mouseY <= (rectangle[1]+rectangle[3])));
}

boolean mouseOverJoystick(int joystick[]) 
{
  if((mouseX >= joystick[0]) && (mouseX <= (joystick[0]+joystick[2])) && (mouseY >= joystick[1]) && (mouseY <= (joystick[1]+joystick[3])))
  {
    //mouseJoystickCoord[joystick][0] = mouseX;
    //mouseJoystickCoord[joystick][1] = mouseY;


    return(true);
  }
  else
  {
    return(false); 
  }

}



void mousePressed()
{
  for(int i=0;i<3;i++)
  {
    if(mouseClickRect(buttonCoord[i])==true)
    {
      print("Clicked");
      println(i);

      buttonState[i]=1;
    }
    else
    {
      buttonState[i]=0;
    }

  }
  

  
}


 void myDelay(int ms){
  int time = millis();
  while(millis()-time < ms);
}


