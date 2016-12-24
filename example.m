% The MIT License (MIT)
%
% Copyright (c) <2014> <Paul Kendrick>
% Copyright (c) <2016> <David Hasenfratz>
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

% make results repeatable
rng(1)

% fisheriris data set:
%  - meas: Matrix of input variables
%  - species: vector of species
load fisheriris
num_bags=20;

% create numerical class labels
species_class(find(strcmp(species, 'setosa'))) = 1;
species_class(find(strcmp(species, 'versicolor'))) = 2;
species_class(find(strcmp(species, 'virginica'))) = 3;

% create decision trees
B = TreeBagger(num_bags, meas, species_class);

% extract decision trees to the header file decTreeConstants.h
extractDecTreeStruct(B, unique(species_class), 1, num_bags);
