extends Node3D

@onready var cube_scene = preload("res://cube.tscn")

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var size = 40
var mscale = 1
var nvisited = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var visited = make_matrix(size, size, 0)
	var vwalls = make_matrix(size+1, size+1, 1)
	var hwalls = make_matrix(size+1, size+1, 1)
	AldousBroder(visited, vwalls, hwalls)
	instantiateWallMaze(vwalls, hwalls)

func instantiateWallMaze(vwalls, hwalls):
	for i in size+1:
		for j in size+1:
			var s = mscale/2.0
			if( hwalls[i][j] and i < size):
				var block = cube_scene.instantiate()
				block.position = Vector3(i*mscale, 0, j*mscale-mscale/2.0)
				block.scale = Vector3(s*2.5, s/2.0, s/2.0)
				add_child(block)
			if( vwalls[i][j] and j < size ):
				var block = cube_scene.instantiate()
				block.position = Vector3(i*mscale-mscale/2.0, 0, j*mscale)
				block.scale = Vector3(s/2.0, s/2.0, s*2.5)
				add_child(block)

func AldousBroder(visited, vwalls, hwalls):
	var p = rand_pos()
	print(p)
	visit(visited, p)
	
	while(nvisited < size*size):
		var next = pickNeighbor(p)
		if ( visited[next[0]][next[1]] == 0 ):
			visit(visited, next)
			removeWall(vwalls, hwalls, p, next)
		p = next

func removeWall(vwalls, hwalls, p1, p2):
	var dx = p2[0] - p1[0]
	var dy = p2[1] - p1[1]
	if(dx == -1):
		var i = p1[0]
		var j = p1[1]
		vwalls[ i ][ j ] = 0
	if(dy == -1):
		var i = p1[0]
		var j = p1[1]
		hwalls[ i ][ j ] = 0
	if(dx == 1):
		var i = p1[0]+dx
		var j = p1[1]
		vwalls[ i ][ j ] = 0
	if(dy == 1):
		var i = p1[0]
		var j = p1[1]+dy
		hwalls[ i ][ j ] = 0

func pickNeighbor(p):
	var i = p[0]
	var j = p[1]
	var all_neighbors = [[i-1,j],[i+1,j],[i,j-1],[i,j+1]]
	var neighbors = []
	for n in all_neighbors:
		if checkValid(n):
			neighbors += [n]
	return neighbors[ rng.randi_range(0, len(neighbors) - 1) ]

func checkValid(point):
	var ival = 0 <= point[0] and point[0] < size;
	var jval = 0 <= point[1] and point[1] < size;
	return ival and jval

func visit(visited, p):
	visited[ p[0] ][ p[1] ] = 1
	nvisited += 1

func rand_pos():
	var i = rng.randi_range(0, size - 1)
	var j = rng.randi_range(0, size - 1)
	return [i,j]

func make_matrix(n,m,v):
	var arr = []
	arr.resize(n)
	for i in len(arr):
		var a = []
		a.resize(m)
		a.fill(v)
		arr[i] = a
	return arr
