PATTERNS = gpio_control sample_team_proj la_control $(addprefix team_projects/, team_xx)
# On the line above, replace xx with your team number (e.g., 01, 03, 12, etc.)

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