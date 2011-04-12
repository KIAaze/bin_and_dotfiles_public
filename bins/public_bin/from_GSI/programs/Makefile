include Makefile.arch

#------------------------------------------------------------------------------

PROGO_1         = add_histos.$(ObjSuf)
PROG_1          = add_histos$(ExeSuf)

PROGO_2         = bgd_constitution.$(ObjSuf)
PROG_2          = bgd_constitution$(ExeSuf)

PROGO_3         = combine_histos.$(ObjSuf)
PROG_3          = combine_histos$(ExeSuf)

PROGO_4         = analysis_function.$(ObjSuf)
PROG_4          = analysis_function$(ExeSuf)

PROGO_5         = check_all_for_integrity.$(ObjSuf)
PROG_5          = check_all_for_integrity$(ExeSuf)

PROGO_6         = check_integrity.$(ObjSuf)
PROG_6          = check_integrity$(ExeSuf)

PROGO_7         = dummy.$(ObjSuf)
PROG_7          = dummy$(ExeSuf)

# PROGO_6         = .$(ObjSuf)
# PROG_6          = $(ExeSuf)

#OBJS          = $(PROGO_1) $(PROGO_2) $(PROGO_3) $(PROGO_4)
#PROGRAMS      = $(PROG_1) $(PROG_2) $(PROG_3) $(PROG_4)

#OBJS          = $(PROGO_1) $(PROGO_2) $(PROGO_3)
#PROGRAMS      = $(PROG_1) $(PROG_2) $(PROG_3)

OBJS          = $(PROGO_1) $(PROGO_5) $(PROGO_6) $(PROGO_7)
PROGRAMS      = $(PROG_1) $(PROG_5) $(PROG_6) $(PROG_7)

# OBJS          = $(PROGO_1)
# PROGRAMS      = $(PROG_1)


#------------------------------------------------------------------------------

.SUFFIXES: .$(SrcSuf) .$(ObjSuf) .$(DllSuf)

all:            $(PROGRAMS)

$(PROG_1):        $(PROGO_1)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_1):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_1) $(LIBS) $(OutPutOpt)$(PROG_1)
		@echo "$@ done"

$(PROG_2):        $(PROGO_2)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_2):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_2) $(LIBS) $(OutPutOpt)$(PROG_2)
		@echo "$@ done"                

$(PROG_3):        $(PROGO_3)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_3):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_3) $(LIBS) $(OutPutOpt)$(PROG_3)
		@echo "$@ done"                

$(PROG_4):        $(PROGO_4)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_4):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_4) $(LIBS) $(OutPutOpt)$(PROG_4)
		@echo "$@ done"                

$(PROG_5):        $(PROGO_5)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_5):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_5) $(LIBS) $(OutPutOpt)$(PROG_5)
		@echo "$@ done"                 

$(PROG_6):        $(PROGO_6)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_6):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_6) $(LIBS) $(OutPutOpt)$(PROG_6)
		@echo "$@ done"                 

$(PROG_7):        $(PROGO_7)
		@echo "============="
		@echo "Creating binary:"
		@echo "============="
		@echo $(PROG_7):
		@echo "============="
		$(LD) $(LDFLAGS) $(PROGO_7) $(LIBS) $(OutPutOpt)$(PROG_7)
		@echo "$@ done"                 

                                                                        
clean:
		@rm -v $(OBJS) $(PROGRAMS)

#------------------------------------------------------------------------------

.$(SrcSuf).$(ObjSuf):
		@echo "============="
		@echo "Creating object file:"
		@echo "============="
		@echo $(CXX)
		@echo "============="
		@echo $(CXXFLAGS)
		@echo "============="
		@echo $(LIBS)
		@echo "============="		
		@echo $<
		@echo "============="
	$(CXX) $(CXXFLAGS) $(LIBS) -c $<
