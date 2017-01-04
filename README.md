README
==

This program takes a decision tree trained in Matlab using TreeBagger or the classification tree function ClassificationTree and outputs the header file decTreeConstants.h containing all the branch information. This header file is used by the attached C++ class to make decisions based on presented features in deployed applications.

This is useful for deploying code developed in Matlab into embedded applications where Matlab is not available and no input files can be read.

Usage
--
The Matlab file extractDecTreeStruct.m takes as input a trained ClassificationTree tree or a TreeBagger classification ensemble, and outputs a header file, which is used by the C++ class DTree in DecisionTreeClass.hpp. DTree has one method decisionTreeFun, which takes as input a series of features and outputs the class (integer number).

For any comments or questions, please email david.hasenfratz@gmail.com

License
--

The MIT License (MIT)

Copyright (c) 2014 Paul Kendrick  
Copyright (c) 2016 David Hasenfratz

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
