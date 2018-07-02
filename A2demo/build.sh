antlr4 MyGram.g4
javac *.java
grun MyGram prog test.in
dot -Tpdf test.dot > test.pdf
