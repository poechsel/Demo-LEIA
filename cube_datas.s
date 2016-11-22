points:
	.word 0x0100						
	.word 0xFF00
	.word 0x0100

	.word 0xFF00
	.word 0xFF00
	.word 0x0100

	.word 0xFF00
	.word 0x0100
	.word 0x0100

	.word 0x0100
	.word 0x0100
	.word 0x0100

	.word 0xFF00
	.word 0xFF00
	.word 0xFF00
	
	.word 0xFF00
	.word 0x0100
	.word 0xFF00

	.word 0x0100
	.word 0x0100
	.word 0xFF00

	.word 0x0100
	.word 0xFF00
	.word 0xFF00
transformed_points:
	.reserve 16
edges:
	.word 0	
	.word 1
	
	.word 0	
	.word 7
	
	.word 0	
	.word 3
	
	.word 1
	.word 2
	
	.word 1	
	.word 4
	
	.word 2		
	.word 3
	
	.word 2		
	.word 5
	
	.word 3	
	.word 6
	
	.word 4	
	.word 7
	
	.word 4
	.word 5
	
	.word 5	
	.word 6
	
	.word 6	
	.word 7
normals:
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100

	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000

	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000

	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000

	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00

	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
transformed_normals:
	.reserve 12

triangles:
	.word 3
	.word 1
	.word 0
	.word 3
	.word 2
	.word 1

	.word 6
	.word 5
	.word 2
	.word 2
	.word 3
	.word 6

	.word 0
	.word 7
	.word 6
	.word 6
	.word 3
	.word 0

	.word 4
	.word 1
	.word 2
	.word 2
	.word 5
	.word 4

	.word 7
	.word 4
	.word 5
	.word 5
	.word 6
	.word 7

	.word 4
	.word 7
	.word 0
	.word 0
	.word 1
	.word 4

