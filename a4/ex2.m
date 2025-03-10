function [D, Ig] = ex2()
	Ia = imread("./tsubuka/scene1.row3.col3.ppm");
	Ib = imread("./tsubuka/scene1.row3.col4.ppm");
	Ig = imread("./tsubuka/truedisp.row3.col3.pgm");

	D = windowing(Ia, Ib, 1);


