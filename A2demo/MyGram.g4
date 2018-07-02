grammar MyGram;


@header {

import java.io.*;
}



@parser::members {
        //AST node count
	int count = 0;
	String graph = "";

	int GetId() {
		return count++;
	}

	
	public class MySet {

		


		int[] ids;
		int size;

		MySet () {
			System.out.println("\n\nInitArray\n-------------");


			ids = new int [100];		
			size = 0;

		
		}

		void ExtendArray(int val) {
			System.out.println("\n\nExtendArray\n-------------\nsize = " + size + "\nval = " + val);

			ids[size] = val;
			size ++;

		
		}

		void AppendArray(MySet s) {
			for (int i = 0; i < s.size; i ++) {
				ExtendArray(s.ids[i]);
			}
		}



	}//MySet

	String ProcessString(String s) {
		String x = "\\" + s.substring(0, s.length() - 1) + "\\\"";
		return x;
	}

	int PrintNode (String label) {
		System.out.println("\n\nPrintNode\n-------------\nlabel = " + label + "\nid = " + count);

		int id = GetId();
		graph += (id + " [label=\"" + label + "\"]\n");
		return id;

	}

	void PrintEdge (int id1, int id2) {
		System.out.println("\n\nPrintEdge\n-------------\nid1 = " + id1 + "\nid2 = " + id2);

		
		if ((id1 != -1) && (id2 != -1)) graph += (id1 + " -> " + id2 + "\n");
		
		

	}

	void PrintEdges (int id, MySet s) {
		System.out.println("\n\nPrintEdges\n-------------\nid = " + id + "\nsize = " + s.size);

		int old = id;
		for (int i = 0; i < s.size; i ++) {
			PrintEdge(old, s.ids[i]);
			old = s.ids[i];
		}
	}

	void PrintGraph () throws IOException {
		System.out.println("\n\nPrintGraph\n-------------");
		

		File file = new File("test.dot");
		file.createNewFile();
		FileWriter writer = new FileWriter(file); 
		writer.write("digraph G {\nordering=out\n" + graph + "\n}\n"); 
		writer.flush();
		writer.close();
		

		System.out.println("digraph G {\nordering=out\n" + graph + "\n}\n");
	}




	
}



//---------------------------------------------------------------------------------------------------
prog
: Class Program '{' method_decls '}'
{

	
	
	int id = PrintNode("Program");


	if ($method_decls.s.size > 0) {
		PrintEdges(id, $method_decls.s);
		
	}

	
	

	try {PrintGraph();} catch(IOException e) {}
}
;










method_decls returns [MySet s]
: m=method_decls method_decl
{
	
	$s = $m.s;
	$s.ExtendArray($method_decl.id);
}
|
{
	$s = new MySet();
	
	
}
;

method_decl returns [int id]
: Void Ident '(' ')' block
{
	$id = PrintNode("MethodDecl");

	PrintEdge($id, PrintNode("void"));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $block.id);
	
}
;







block returns [int id]
: '{' var_decls statements '}'
{
	$id = -1;
	if ($var_decls.s.size > 0) {
		$id = PrintNode("Block");
		PrintEdges($id, $var_decls.s);
		
	}
	if ($statements.id != -1) {
		if ($id == -1) $id = PrintNode("Block");
		PrintEdge($id, $statements.id);
	}
}
;

var_decls returns [MySet s]
: v=var_decls var_decl ';'
{
	$s = $v.s;
	$s.ExtendArray($var_decl.id);
}
| 
{
	$s = new MySet();
}
;


var_decl returns [int id]
: Type Ident ';'
{
	$id = PrintNode("VarDecl");
	
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
}
;









statements returns [int id]
: statement t=statements
{
	if ($t.id != -1) {
		$id = $statement.id;
		PrintEdge($id, $t.id);
		
	} else {
		$id = $statement.id;
	}
}
|
{
	$id = -1;
}
;





statement returns [int id]
: location eqOp expr ';'
{
	$id = PrintNode("Assign");
	PrintEdge($id, $location.id);
	PrintEdge($id, PrintNode($eqOp.text));
	PrintEdge($id, $expr.id);
}
;







expr returns [int id]
: literal
{
	$id = PrintNode("ConstExpr");
	PrintEdge($id, PrintNode($literal.text));
}
| location
{
	$id = PrintNode("LocExpr");
	PrintEdge($id, $location.id);
}
| e1=expr AddOp e2=expr
{
	$id = PrintNode("BinExpr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($AddOp.text));
	PrintEdge($id, $e2.id);
}
;


location returns [int id]
:Ident
{
	$id = PrintNode("Loc");
	PrintEdge($id, PrintNode($Ident.text));
}
;


num
: DecNum
;

literal
: num
;

eqOp
: '='
;


//-----------------------------------------------------------------------------------------------------------
fragment Delim
: ' '
| '\t'
| '\n'
;

fragment Letter
: [a-zA-Z]
;

fragment Digit
: [0-9]
;

fragment HexDigit
: Digit
| [a-f]
| [A-F]
;

fragment Alpha
: Letter
| '_'
;

fragment AlphaNum
: Alpha
| Digit
;


WhiteSpace
: Delim+ -> skip
;



Char
: '\'' ~('\\') '\''
| '\'\\' . '\'' 
;

Str
:'"' ((~('\\' | '"')) | ('\\'.))* '"'
; 



Class
: 'class'
;

Program
: 'Program'
;

Void
: 'void'
;

If
: 'if'
;

Else
: 'else'
;

For
: 'for'
;

Ret
: 'return'
;

Brk
: 'break'
;

Cnt
: 'continue'
;

Callout
: 'callout'
;

DecNum
: Digit+
;


HexNum
: '0x'HexDigit+
;




BoolLit
: 'true'
| 'false'
;

Type
: 'int'
| 'boolean'
;

Ident
: Alpha AlphaNum* 
;

RelOp
: '<='
| '>=' 
| '<'
| '>'
| '=='
| '!='
;

AssignOp
: '+='
| '-='
;

MulDiv
: '*'
| '/'
| '%'
;

AddOp
: '+'
;

SubOp
: '-'
;

AndOp
: '&&'
;

OrOp
: '||'
;




