PROC SQL;
	CREATE TABLE mytab AS 
		select DISTINCT Make 
			FROM sashelp.cars;
QUIT;

data mytab;
	SET mytab;
	RANDS = round(RAND("uniform")*100,2);
	num=_n_;
RUN;

DATA CARS ;
	if 0 then set mytab;
	Declare hash mycars(dataset:'mytab' );
	mycars.definekey('Make');
	mycars.definedata('RANDS','num');
	mycars.definedone();

	Declare hash myoder(ordered:'descending');
	myoder.definekey('Make');
	myoder.definedata('Make','Weight','avgWeight','RANDS','num');
	myoder.definedone();
	
	Declare HITER C('avgWeight');

	set sashelp.cars end=eof;
	RC = mycars.find();
	IF RC ne 0 THEN CALL missing(Rands, Num);
	avgWeight= Weight/Rands;
	OUTPUT CARS;
	If Make='Acura' THEN myoder.add();
	If eof=1 THEN  myoder.OUTPUT(dataset:'Acura');
	format avgWeight comma6.;

RUN;