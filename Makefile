SOURCE=		src
EDUIDCOMMON=	../eduid-common/src
EDUIDUSERDB=	../eduid-userdb/src
PIPCOMPILE=	pip-compile -v --generate-hashes --extra-index-url https://pypi.sunet.se/simple

test:
	pytest

reformat:
	isort --line-width 120 --atomic --project eduid_queue $(SOURCE)
	black --line-length 120 --target-version py37 --skip-string-normalization $(SOURCE)

typecheck:
	mypy --ignore-missing-imports $(SOURCE)

typecheck_extra:
	mypy --ignore-missing-imports $(EDUIDCOMMON) $(EDUIDUSERDB) $(SOURCE)

update_translations:
	python setup.py extract_messages
	python setup.py update_catalog
	$(info --- INFO ---)
	$(info Upload message.pot to Transifex, translate.)
	$(info Download for_use_X.po to translations/XX/LC_MESSAGES/messages.po.)
	$(info --- INFO ---)

compile_translations:
	python setup.py compile_catalog --use-fuzzy

%ments.txt: %ments.in
	CUSTOM_COMPILE_COMMAND="make update_deps" $(PIPCOMPILE) $< > $@

update_deps: $(patsubst %ments.in,%ments.txt,$(wildcard *ments.in))
