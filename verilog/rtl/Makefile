
# Designs for bus wrap generation and initialization
PATTERNS = ffram gpio_control sample_team_proj la_control $(addprefix team_projects/, team_01 team_03 team_04 team_05 team_06 team_07 team_08 team_09 team_10 team_12)

#Bus Wrap Initialize
.PHONY: initialize
initialize:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i &&\
			make generate_wb_yaml \
		) ; \
	done

#Bus Wrap Generate
generate:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i &&\
		 	make generate_wb_wrapper \
		) ; \
	done
