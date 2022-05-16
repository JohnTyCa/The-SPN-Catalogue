from numpy import * #many different maths functions
import os #handy system and path functions
from numpy import linspace
from scipy.interpolate import splprep, splev
from math import sqrt
import copy

#euclidian distance
# usage d = distance([0,0],[10,10])
def distance(p1,p2):
    return sqrt((p2[0] - p1[0]) ** 2 +(p2[1] - p1[1]) ** 2)

# area of any convex polygon, starting from the vertices (see it.wikipedia.org/wiki/Poligono)
# usage area = gaussarea(p) where p is a list of lists: [[0,0],[2,3],[30,23]]
def gaussarea(poly):

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

# return the xy coordinate of the centoid of a set of points
# usage area = analysecentroid(p) where p is a list of lists: [[0,0],[2,3],[30,23]]
def analysecentroid(matrix):
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

    for i in range(len(matrix)):
        sx = sx + matrix[i][0]
        sy = sy + matrix[i][1]
        
    svalue = len(matrix)
    
    centroid[0] = sx/svalue
    centroid[1] = sy/svalue
    
    return centroid
 
#return the principal axis of a set of points
def analyseprincipalaxis(matrix):
    sxy =0.0
    sx = 0.0
    sy =0.0
    svalue=0
    centroid=[0,0]
    
    centroid = analysecentroid(matrix)
        
    for yy in range(len(matrix)):
        for xx in range(len(matrix[0])):
            if matrix[yy][xx] >0:
                sxy += (xx-centroid[0]) * (yy-centroid[1])
                sx += (xx-centroid[0]) * (xx-centroid[0])
                sy += (yy-centroid[1]) * (yy-centroid[1])
    return sxy


 # this is a function to count sequences of numbers, it returns a list in which
# each entry is a sequence, so [2,5] means it found a pair and a sequence of 5 numbers that were the same in order
# list can be interegers or anything else
def analysecontent(memory_of_list):

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
    
#a =[[-20, -10], [20, 10], [-20, 10], [20, -10]]
#centroid = analysecentroid(a)
#print a - centroid

 