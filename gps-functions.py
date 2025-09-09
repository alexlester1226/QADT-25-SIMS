# Code for creating Local GPS waypoints for plane navigation
# Code for converting Local GPS waypoints to Lat, Long coordinates given a reference
# Author: Alex Lester - QADT Task 1

import math

def print_arr(arr, str): # simple function to print elements of an array with a header tag
    print(str)
    for i in range(0, len(arr)):
        print(arr[i])
    print("\n")


def get_coordinates(init_pos): # translates (x,y) coordinates to long and lat coordinates
    global xy_points
    arr = [init_pos]
    for i in range(1, len(xy_points)):
        # gets the change in x and y coordinates between points
        dx = xy_points[i][0] - xy_points[i - 1][0]
        dy = xy_points[i][1] - xy_points[i - 1][1]

        # translates the change from m -> degrees
        dlat = delta_Lat(dy)
        dlong = delta_Long(dx)

        # updates coordinate based on delta variables and previous position
        current_coordinate = (arr[i - 1][0] + dlat, arr[i - 1][1] + dlong)
        arr.append(current_coordinate)

    # prints array
    print_arr(arr, "lat (N/S), long (E/W)")
    return arr


def delta_Lat(x):
    return x * (0.0008983/100)  # converts meters --> degrees Lat


def delta_Long(x):
    global lat
    return x/(111320 * math.cos(coordinates[0]))  # converts meters --> degrees long [based on lat]


def create_kml(points):
    # creates kml file
    with open("map.kml", "w") as f:
        # writes opening code
        f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
        f.write("<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n")
        f.write("  <Document>\n")
        f.write("\t<name>Stages Map</name>\n")
        f.write("\n")

        # for loop to write points on map
        for i in range(0, len(points)):
            create_kml_point(f, f'Stage {i + 1}', points[i])

        f.write("  </Document>\n")
        f.write("</kml>\n")

    f.close()  # close file


def create_kml_point(file, str, point):
    file.write("\t<Placemark>\n")
    file.write(f"\t  <name>{str}</name>\n")
    file.write("\t  <Point>\n")
    file.write(f"\t    <coordinates>{point[1]},{point[0]},0</coordinates>\n")
    file.write("\t  </Point>\n")
    file.write("\t</Placemark>\n\n")



# Center(ish) Point of Field
# Latitude     Longitude
# 50.10217575 -110.73922868478785

# global variables
coordinates = (50.10217575, -110.73922868478785)
xy_points = [(0, 0), (0, 100), (-60, 100), (-60, -100), (0, -100), (0, 100), (60, 100), (60, -100)]
local_degree_points = []
global_degree_points = []

if __name__ == '__main__':
    print_arr(xy_points, "(x, y)")
    global_degree_points = get_coordinates(coordinates)
    create_kml(global_degree_points)

