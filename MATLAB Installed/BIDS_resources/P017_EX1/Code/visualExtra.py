''' This is the version 2.0 of visualExtra.py it includes the following functions:
def distance(p1,p2):
def polar2cartesian(r,a):
def cartesian2polar(x,y):
def computeArea(poly):
def computePerimeter(poly):
def computeCentroid(poly):
def computePrincipalAxis(poly):

def transVertices(vertices=[[0,0],[0,0]], pos=[0,0], a=90):
def rotateVertices(vertices=[[0,0],[0,0]], pos=[0,0], a=90):
def rotateVertex(vertex=[0,0], pos=[0,0], a=90):
def spline(vertices =[[0,0],[0,0]], smooth=10, resolution=2000, order=3):

def generateCoordsPolar(n=10, pos=[0,0], minDist=1, gapAxis=2, radius=100, start=0, stop=360):
def generateSymmetry(symmetry='no', axes=0, ndots=32, radius=300, minDist=10, gapAxis=8):
def addNoiseCoords(vertices=[[0,0],[0,0]], axes =0, radius=300, minDist=1, noise=10):
def overlapCoords(vertices1=[[0,0],[0,0]], vertices2=[[0,0],[0,0]], minDist=1):
   
def analyseContent(memory_of_list):
'''

from numpy import * #many different maths functions
import os #handy system and path functions
from numpy import linspace
from scipy.interpolate import splprep, splev
from math import sqrt, atan2
import copy

#euclidian distance
# usage d = distance([0,0],[10,10])
def distance(p1,p2):
    return sqrt((p2[0] - p1[0]) ** 2 +(p2[1] - p1[1]) ** 2)

#convert polar to cartesian, angle is in degree
# usage [x,y] = polar2cartesian(10, 20):
def polar2cartesian(r,a):
    
    a = deg2rad(a)
    x = r * cos(a)
    y = r * sin(a)
    return [x,y]

#convert cartesian to polar, angle is in degree
# usage [r,a] = cartesian2polar(20, 30)
def cartesian2polar(x,y):
    
    r = sqrt(x*x+y*y)
    a = 90 - rad2deg(atan2(x,y))
    return [r,a]
    
# area of any convex polygon, starting from the vertices (see it.wikipedia.org/wiki/Poligono) using Gauss method
# usage area = computeArea(p) where p is a list of lists: [[0,0],[2,3],[30,23]]
def computeArea(poly):

    temp1 = 0
    temp2 =0
    poly2 = copy.deepcopy(poly)
    poly1 = copy.deepcopy(poly)
    poly1.append(poly[0])
#    print poly1, poly2
    
    for i in range(len(poly2)):
        temp1 = temp1 + poly1[i][0]*poly1[i+1][1]

    for i in range(len(poly2)):
        temp2 = temp2 + poly1[i+1][0]*poly1[i][1]
       
    return (0.5 * abs(temp1 - temp2))
    
#returns the total length of a polygon
def computePerimeter(poly):
    if len(poly) <=1:
        return 0
    total =0
    for i in range(len(poly) -1):
        total = total +distance(poly[i],poly[i+1])
    total = total +distance(poly[i+1],poly[0])
    return total

# return the xy coordinate of the centoid of a set of points
# usage area = computeCentroid(p) where p is a list of lists: [[0,0],[2,3],[30,23]]
def computeCentroid(poly):
    sxy =0.0
    sx =0.0
    sy =0.0
    svalue=0
    centroid=[0,0]
           
#    for xx in range(len(matrix)):
#        for yy in range(len(matrix[0])):
#            if matrix[xx][yy] >0:
#                sx = sx+xx
#                sy =sy+yy
#                svalue = svalue+1
#                print 'xx', matrix[xx][0], 'yy', matrix[xx][1]
#                print svalue, matrix[xx][yy]

    for i in range(len(poly)):
        sx = sx + poly[i][0]
        sy = sy + poly[i][1]
        
    svalue = len(poly)
    
    centroid[0] = sx/svalue
    centroid[1] = sy/svalue
    
    return centroid
 
#return the principal axis of a set of points
def computePrincipalAxis(poly):
    sxy =0.0
    sx = 0.0
    sy =0.0
    svalue=0
    centroid=[0,0]
    
    centroid = computeCentroid(poly)
        
    for yy in range(len(poly)):
        for xx in range(len(poly[0])):
            if poly[yy][xx] >0:
                sxy += (xx-centroid[0]) * (yy-centroid[1])
                sx += (xx-centroid[0]) * (xx-centroid[0])
                sy += (yy-centroid[1]) * (yy-centroid[1])
    return sxy

#returns the coords of a poly v after translation by [x,y]
def transVertices(vertices=[[0,0],[0,0]], pos=[0,0]):

    angle = a * 3.14159 /180.
    newv = copy.deepcopy(vertices)  #just to have the same dimensions
    
    for i in range(len(vertices)):
        newv[i][0] = pos[0] + cos(angle) * (vertices[i][0] -pos[0]) - sin(angle) * (vertices[i][1] - pos[1])
        newv[i][1] = pos[1] + sin(angle) * (vertices[i][0] -pos[0]) + cos(angle) * (vertices[i][1] -pos[1])

    return newv
    
#returns the coords of a poly v after rotation by angle a (in degrees), use type="polar" if polar coordinates
def rotateVertices(vertices=[[0,0],[0,0]], pos=[0,0], a=90, type='cartesian'):

    if type =='cartesian':
        angle = a * 3.14159 /180.
        newv = copy.deepcopy(vertices)  #just to have the same dimensions
        
        for i in range(len(vertices)):
            newv[i][0] = pos[0] + cos(angle) * (vertices[i][0] -pos[0]) - sin(angle) * (vertices[i][1] - pos[1])
            newv[i][1] = pos[1] + sin(angle) * (vertices[i][0] -pos[0]) + cos(angle) * (vertices[i][1] -pos[1])
    elif type =='polar':
         newv = [[x[0], x[1]+a] for x in vertices] 
        
    return newv

def rotateVertex(vertex=[0,0], pos=[0,0], a=90):
    
    angle = a * 3.14159 /180.
    newv = copy.deepcopy(vertex)  #just to have the same dimensions
    
    newv[0] = pos[0] + cos(angle) * (vertex[0] -pos[0]) - sin(angle) * (vertex[1] - pos[1])
    newv[1] = pos[1] + sin(angle) * (vertex[0] -pos[0]) + cos(angle) * (vertex[1] -pos[1])

    return newv
    
#returns the cords of a smooth version of the original polygon
#the level of smoothing is set by the third parameters
def spline(vertices =[[0,0],[0,0]], smooth=10, resolution=2000, order=3):
    # spline parameters
    #smooth=1000 # smoothness parameter
    #k=3 # spline order 3=cubic
    nest=-1 # estimate of number of knots needed (-1 = maximal)

    #this simply split the list of x and y into two lists
    x,y =zip(*vertices)
    
    # find the knot points
    tckp,u = splprep([x,y], s=smooth, k=order, nest=nest, per=1)
    
    # evaluate spline, including interpolated points
    xnew,ynew = splev(linspace(0,1,resolution), tckp)
    
    #returns a list of x and y pairs as vertices of the new smoothed polygon
    return zip(xnew,ynew)

        
# generate ndots coordinates, centrex centrey are the position, 
# radius of the circle, ndots, symmetry in ['r','no','c'], 
# minDist between coords. The rule for minDist when we use a gaussian mask is as follows
#For size x, if you want that 68% of the object never overlaps another minDist has to be two SD 
#minDist = x / 6. *  2.
#If you want that 95% never overlaps
#minDist = x / 6. *  2. * 1.96
#Other values like 90% or 80% are respectively
#minDist = x / 6. *  2. * 1.64
#minDist = x / 6. *  2. * 1.3
''' From: http://www.anderswallin.net/2009/05/uniform-random-points-in-a-circle-using-polar-coordinates/
    The task is to generate uniformly distributed numbers within a circle of radius R in the (x,y) plane. 
    At first polar coordinates seems like a great idea, to pick a radius r uniformly distributed in [0, R], and 
    then an angle theta uniformly distributed in [0, 2pi]. BUT, you end up with an exess of points near the 
    origin (0, 0)!  there needs to be more points generated further out (at large r), than close to zero. 
    The radius must not be picked from a uniform distribution, but one that goes as
    pdf_r = (2/R^2)*r
    That's easy enough to do by calculating the inverse of the cumulative distribution, and we get for r:
    r = R*sqrt( rand() )
    '''
def generateCoordsPolar(n=10, pos=[0,0], minDist=1, gapAxis=2, radius=100, start=0, stop=360):
    
#    if  gapAxis == None: gapAxis = minDist

    coords =[]
    n =int(round(n))
    minDist2 = minDist / 2.
    
    for i in range(n):
        farEnough = False
        while farEnough == False:
#            print minDist, radius
            r = gapAxis + int((radius - gapAxis)*sqrt( random.rand()))
#                r= random.randint(2, radius)
            a =random.randint(start, stop)
            item1 = polar2cartesian(r,a)
            right = polar2cartesian(r,start)
            left = polar2cartesian(r,stop)
            farEnough = True
            if distance(item1, left) <minDist2:
                farEnough =False
            elif distance(item1, right) <minDist2:
                farEnough =False
            else:
                for j in coords:
                    item2 = polar2cartesian(j[0], j[1])
                    if distance(item1, item2) <minDist:
                        farEnough =False
                        break
        coords.append([r,a])
        
    return coords

# prepare list of positions with a particular symmetry type and number of axes
# numbre of axes also matter for no symmetry to divide the number of elements into quadrants
def generateSymmetry(symmetry='no', axes=0, ndots=32, radius=300, minDist=10, gapAxis=8):

    shapeFinal =[]
    
    if axes>0:
        n = int(round(ndots / (axes*2.)))       #example for 4 axes and 80 dots then n is 10
        stop = (360. / (axes*2.))   #example for 4 axes start =0 stop = 45
    else:
        n = int(round(ndots))
        stop = 360
    
    if symmetry=='no':
        
        start1 =0
        stop1 = stop
        
        if axes>0:
            for i in range(axes*2):
                shape_v1 = generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=start1, stop=stop1)
                shapeFinal.extend(shape_v1)
                start1 = start1 +stop
                stop1 = stop1 + stop
        else:
            shapeFinal = generateCoordsPolar(n=ndots, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=360)
            
    elif symmetry =='r':
        
        shape_v1 = generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=stop)
        if axes==1:
            shape_v2 = [[x[0], 360 -x[1]] for x in shape_v1]
            shapeFinal = shape_v1 + shape_v2
        elif axes==2:
            shape_v2 = [[x[0], 180 -x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 360 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 180 -x[1]] for x in shape_v4]            
            shapeFinal =shape_v1 + shape_v2  + shape_v3 + shape_v4
        elif axes==3:
            shape_v2 = [[x[0], 120 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 120 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 240 -x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 240 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 360 -x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6
        elif axes==4:
            shape_v2 = [[x[0], 90 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 180 -x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 180 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 270 -x[1]] for x in shape_v1]       
            shape_v7 = [[x[0], 270 +x[1]] for x in shape_v1]       
            shape_v8 = [[x[0], 360 -x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6 + shape_v7 + shape_v8

    elif symmetry =='c':
        
        shape_v1 = generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=stop)
        if axes==1:
            shape_v2 = [[x[0], 180 +x[1]] for x in shape_v1]
            shapeFinal = shape_v1 + shape_v2
        elif axes==2:
            shape_v2 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 180 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 270 +x[1]] for x in shape_v1]            
            shapeFinal =shape_v1 + shape_v2  + shape_v3 + shape_v4
        elif axes==3:
            shape_v2 = [[x[0], 60 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 120 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 180 +x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 240 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 300 +x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6
        elif axes==4:
            shape_v2 = [[x[0], 45 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 135 +x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 180 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 225 +x[1]] for x in shape_v1]       
            shape_v7 = [[x[0], 270 +x[1]] for x in shape_v1]       
            shape_v8 = [[x[0], 315 +x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6 + shape_v7 + shape_v8
            
    return shapeFinal

# add pixel noise around original position
def addNoiseCoords(vertices=[[0,0],[0,0]], axes =0, radius=300, minDist=1, noise=10):

    if noise ==0:
        return vertices
    n = len(vertices)
    coords = []
    vc = [polar2cartesian(i[0],i[1]) for i in vertices]  # vertices as cartesian coords
    
    for i in range(n):
        farEnough = False
        while farEnough == False:

            r = int(noise* random.rand())
            a =random.randint(0,360)
            cartesianNoise = polar2cartesian(r,a)
            item = vc[i]
            itemNew = [item[0]+cartesianNoise[0],item[1]+cartesianNoise[1]]
            itemNewPolar = cartesian2polar(itemNew[0],itemNew[1])

            farEnough = True
            if itemNewPolar[0] >radius or itemNewPolar[0] <minDist:  # this is not to go outside the circular region, or to close to the centre
                    farEnough =False
            elif i>0:
                for j in coords:
                    test = polar2cartesian(j[0], j[1])
                    if distance(test, itemNew) <minDist:   # this is not to avoid overlap
                        farEnough =False
        coords.append(cartesian2polar(itemNew[0],itemNew[1]))

    return coords

# mix a certain percentage of locations from another set
def mixCoords(ver1=[[0,0],[0,0]], ver2=[[0,0],[0,0]], axes =0, prop=50):

    if len(ver1) != len(ver2):
        return False
    shapeNew = [] #copy.deepcopy(ver1)  #
    shapeOld = []  #copy.deepcopy(ver1)  #

    if axes>0:
        n = int(len(ver1) / (axes*2))
    elif axes==0:
        n = len(ver1)
    unchanged = int(n * (1.- prop/100.))    # this has to give an integer, so for 4 axes, 32 dots, and 50% we have 4/2 which is 2
    pick = ones(n)
    pick[:unchanged] = 0
    position =0
    
    for sector in range(axes*2):
        posSector =0
        random.shuffle(pick)

        for i in range(n):
            if pick[posSector] == 1:
#                shapeNew.append(ver2[position])
                shapeNew.append(ver2[position])
            else:
#                shapeNew[position] = ver2[position]
                shapeOld.append(ver2[position])
            position = position +1
        posSector = posSector +1
        
    return shapeOld, shapeNew

# check whether there is any element too close comparing two sets of vertices
# return true if there is ovrelap, false if no overlap
def overlapCoords(vertices1=[[0,0],[0,0]], vertices2=[[0,0],[0,0]], minDist=1):

#    vcopy1 = copy.deepcopy(vertices1)
#    vcopy2 = copy.deepcopy(vertices2)
    
    vc1 = [polar2cartesian(i[0],i[1]) for i in vertices1]  # vertices as cartesian coords
    vc2 = [polar2cartesian(i[0],i[1]) for i in vertices2]  # vertices as cartesian coords

    for i in vc1:
        for  j in vc2:
            if distance(i, j) <minDist:   # this is not to avoid overlap
                return True

    return False
    
# this is a function to count sequences of numbers, it returns a list in which
# each entry is a sequence, so [2,5] means it found a pair and a sequence of 5 numbers that were the same in order
# list can be interegers or anything else
def analyseContent(memory_of_list):

    memory = list(memory_of_list)   # this is so that the outer object is not modified
 #   memory.extend([(i+1)*1000 for i in range(len(memory))])   #add a list of large numbers and double the length of the list
    memory.append(memory[-1]+1)  #adds a number at the end that is different from the last (so no sequence is created there)

    i =0
    same =0
    found =[]
    
    while i <len(memory)-1:

        while memory[i] == memory[i+1]:
            same = same +1
            i=i+1
        i = i+1
        if same >0:
            found.append(same+1)
            same =0
        
    return found
    

#
#clock = core.Clock()
#t = clock.getTime()
#n =1000
#t = clock.getTime()
#for i in range(n):
#    target = generateSymmetry(symmetry='r', axes=1, ndots=100, radius=200, minDist=5.3, gapAxis=3)
#    print len(target)
#elapsed = clock.getTime() - t
#print elapsed / float(n)
#
#t = clock.getTime()
#for i in range(n):
#    target = generateSymmetry(symmetry='no', axes=1, ndots=100, radius=200, minDist=5.3, gapAxis=3)
#    print len(target)
#elapsed = clock.getTime() - t
#print elapsed / float(n)

#a =[[-20, -10], [20, 10], [-20, 10], [20, -10]]
#centroid = analysecentroid(a)
#print a - centroid
#[x,y] =polar2cartesian(100., 280.)
#print "x,y", x,y
#[r,a] =cartesian2polar(x,y)
#print "r,a", r,a
#[x,y] =polar2cartesian(r,a)
#print "x,y", x,y
#v = rotateVertices(vertices=[[10,20],[2,60]])
#print v
#v = rotateVertex(vertex=[10,20])

