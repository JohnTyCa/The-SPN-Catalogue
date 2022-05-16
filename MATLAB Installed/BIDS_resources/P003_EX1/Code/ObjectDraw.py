void DrawObject(int pattern, int nofObjects)
{
int maxx =80;
int maxy =220;
int n = 12;
int size =7;
int x, y, x1, y1;
int vx[n+1];
int vy[n+1];
int i;
int a=30;
int b=20;
int sides =12;
# pattern ='n';
nofObjects ='2';

#drawRect(0,0, 2*a, maxy, false);
#drawRect(0,0, 2*(a+maxx), maxy, false);

switch(pattern)

case 'v': #vertical reflection
glBegin(GL_LINE_STRIP);
for(i=0; i<n; i++)           
{
vx[i] = a + int(0.5 + randomUnit() * maxx);
vy[i] = -(maxy/2) + i*b;     // y goes from -110 to 110
glVertex2f(vx[i], vy[i]); 

#vx[i] = a + int(0.5 + randomUnit() * maxx);
#vy[i] = -(maxy/2) + i*b; # + int(0.5 + randomUnit() * maxy);			
#glVertex2f(vx[i], vy[i]); 

if(nofObjects=='1')
{
glEnd();
glBegin(GL_LINE_STRIP);
glVertex2f(vx[0], vy[0]); 
}
else
{
glVertex2f(200, vy[n-1]); 
glVertex2f(200, vy[0]); 
glVertex2f(vx[0], vy[0]);
glEnd();
glBegin(GL_LINE_STRIP);
}

for(i=0; i<n; i++)
{
#vx[i] = a + int(0.5 + randomUnit() * maxx);
#y = -(n/2) + i*b; # + int(0.5 + randomUnit() * maxy);
glVertex2f(-vx[i], vy[i]); 

}
if(nofObjects=='1')
{
glVertex2f(vx[n-1], vy[n-1]); 
}
else
{
glVertex2f(-200, vy[n-1]); 
glVertex2f(-200, vy[0]); 
glVertex2f(-vx[0], vy[0]);
}

glEnd();
break;

case 't': # translation
glBegin(GL_LINE_STRIP);
for(i=0; i<n; i++)           

vx[i] = a + int(0.5 + randomUnit() * maxx);
vy[i] = -(maxy/2) + i*b;     // y goes from -110 to 110
glVertex2f(vx[i], vy[i]); 


#vx[i] = a + int(0.5 + randomUnit() * maxx);
#vy[i] = -(maxy/2) + i*b; # + int(0.5 + randomUnit() * maxy);
#glVertex2f(vx[i], vy[i]); 

if(nofObjects=='1')
{
glEnd();
glBegin(GL_LINE_STRIP);
glVertex2f(vx[0], vy[0]); 
}
else
{
glVertex2f(200, vy[n-1]); 
glVertex2f(200, vy[0]); 
glVertex2f(vx[0], vy[0]);
glEnd();
glBegin(GL_LINE_STRIP);
}

for(i=0; i<n; i++)
{
#				//				vx[i] = a + int(0.5 + randomUnit() * maxx);
#				//				y = -(n/2) + i*b; // + int(0.5 + randomUnit() * maxy);
glVertex2f(vx[i] -maxx -2*a, vy[i]); 

}
if(nofObjects=='1'
{
glVertex2f(vx[n-1], vy[n-1]); 
}
else
{
glVertex2f(-200, vy[n-1]); 
glVertex2f(-200, vy[0]); 
glVertex2f(vx[0] -maxx -2*a, vy[0]);
}

glEnd();
break;

case 'r':    	/* rotation  */
for(i=0; i<n; i++)
{
x  = a + int(0.5 + randomUnit() * maxx);
y  = b + int(0.5 + randomUnit() * maxy);
x1 = a + int(0.5 + randomUnit() * maxx);
y1 = -b - int(0.5 + randomUnit() * maxy);

drawShape(x, y, size, sides, true);
drawShape(x1, y1, size, sides, true);

glRotated(180., 0., 0., 1.);
drawShape(x, y, size, sides, true);
drawShape(x1, y1, size, sides, true);
glLoadIdentity();
}	
break;

case 'n':	 #no regularity
glBegin(GL_LINE_STRIP);
for( i=0; i<n; i++)
{
vx[i] = a + int(0.5 + randomUnit() * maxx);
vy[i] = -(maxy/2) + i*b; // + int(0.5 + randomUnit() * maxy);
glVertex2f(vx[i], vy[i]); 

}

vx[n] = vx[i-1];   # remember the last
vy[n] = vy[i-1];		


if(nofObjects=='1')
{
glEnd();
glBegin(GL_LINE_STRIP);
glVertex2f(vx[0], vy[0]); 
}
else
{
glVertex2f(200, vy[n-1]); 
glVertex2f(200, vy[0]); 
glVertex2f(vx[0], vy[0]);
glEnd();
glBegin(GL_LINE_STRIP);
}

for( i=-0; i<n; i++)
{
vx[i] = a + int(0.5 + randomUnit() * maxx);
y = -(n/2) + i*b; // + int(0.5 + randomUnit() * maxy);
glVertex2f(-vx[i], vy[i]); 



f(nofObjects=='1')
{
glVertex2f(vx[n], vy[n]); 
}
else
{
glVertex2f(-200, vy[n-1]); 
glVertex2f(-200, vy[0]); 
glVertex2f(-vx[0], vy[0]);
}

glEnd();
break;
}
}    
