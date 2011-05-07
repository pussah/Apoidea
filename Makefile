CC = erlc
FILES = network.erl worker.erl drone.erl crypto.erl

# TODO: dependencies
build: $(FILES)
	$(CC) $(FILES)
	
clean:
	rm -f *.beam erl_crash.dump

# TODO: clean up
test: build
	erl -noshell -s network test -s init stop
	erl -noshell -s worker test -s init stop
	erl -noshell -s crypto test -s init stop
	erl -noshell -s drone test -s init stop
	
docs:
	erl -noshell -eval "edoc:files(["`echo "$(FILES)" | sed s/\ /,/g`"], [{dir, doc}])." -s init stop
	
rebuild: clean build
