# Build, package and clean Fatiando
.PHONY: package docs build test clean help

help:
	@echo "Commands:"
	@echo ""
	@echo "    build         build the extension modules inplace"
	@echo "    docs          build the pdf and html documentation"
	@echo "    test          run the test suite (including doctests)"
	@echo "    package       create source distributions"
	@echo "    package-win   create a windows installer"
	@echo "    upload        upload the package to PyPI (CAREFUL!)"
	@echo "    test-upload   make a dry run of the upload process"
	@echo "    clean         clean up"
	@echo ""

build:
	@python setup.py build_ext --inplace

docs: clean
	@cd doc; make html; make latexpdf

test:
	@nosetests fatiando

package: docs
	@python setup.py sdist --formats=zip,gztar

package-win: docs
	@python setup.py bdist_wininst

upload: package
	@python setup.py upload

test-upload: package
	@python setup.py upload --show-response --dry-run

clean:
	@find . -name "*.so" -exec rm -v {} \;
	@find "fatiando" -name "*.c" -exec rm -v {} \;
	@find . -name "*.pyc" -exec rm -v {} \;
	@rm -rvf build dist doc/_build MANIFEST
	@# Trash generated by the doctests
	@rm -rvf mydata.txt mylogfile.log