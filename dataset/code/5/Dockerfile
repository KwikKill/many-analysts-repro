FROM thebloodman/r-old:3.2.0

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cran.r-project.org/"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install R packages (use archive URLs for old versions)
RUN wget -O /tmp/Matrix.tar.gz https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.1-5.tar.gz && \
    R CMD INSTALL /tmp/Matrix.tar.gz && rm -f /tmp/Matrix.tar.gz

RUN wget -O /tmp/Rcpp.tar.gz https://cran.r-project.org/src/contrib/Archive/Rcpp/Rcpp_0.11.6.tar.gz && \
    R CMD INSTALL /tmp/Rcpp.tar.gz && rm -f /tmp/Rcpp.tar.gz

RUN wget -O /tmp/inline.tar.gz https://cran.r-project.org/src/contrib/Archive/inline/inline_0.3.14.tar.gz && \
    R CMD INSTALL /tmp/inline.tar.gz && rm -f /tmp/inline.tar.gz

RUN wget -O /tmp/RcppEigen.tar.gz https://cran.r-project.org/src/contrib/Archive/RcppEigen/RcppEigen_0.3.2.1.0.tar.gz && \
    R CMD INSTALL /tmp/RcppEigen.tar.gz && rm -f /tmp/RcppEigen.tar.gz

RUN wget -O /tmp/BH.tar.gz https://cran.r-project.org/src/contrib/Archive/BH/BH_1.58.0-1.tar.gz && \
    R CMD INSTALL /tmp/BH.tar.gz && rm -f /tmp/BH.tar.gz

RUN wget -O /tmp/StanHeaders.tar.gz https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.9.0.tar.gz && \
    R CMD INSTALL /tmp/StanHeaders.tar.gz && rm -f /tmp/StanHeaders.tar.gz

RUN wget -O /tmp/plyr.tar.gz https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.1.tar.gz && \
    R CMD INSTALL /tmp/plyr.tar.gz && rm -f /tmp/plyr.tar.gz

RUN wget -O /tmp/digest.tar.gz https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.8.tar.gz && \
    R CMD INSTALL /tmp/digest.tar.gz && rm -f /tmp/digest.tar.gz

RUN wget -O /tmp/gtable.tar.gz https://cran.r-project.org/src/contrib/Archive/gtable/gtable_0.2.0.tar.gz && \
    R CMD INSTALL /tmp/gtable.tar.gz && rm -f /tmp/gtable.tar.gz

RUN wget -O /tmp/stringr.tar.gz https://cran.r-project.org/src/contrib/Archive/stringr/stringr_0.6.2.tar.gz && \
    R CMD INSTALL /tmp/stringr.tar.gz && rm -f /tmp/stringr.tar.gz

RUN wget -O /tmp/reshape2.tar.gz https://cran.r-project.org/src/contrib/Archive/reshape2/reshape2_1.4.1.tar.gz && \
    R CMD INSTALL /tmp/reshape2.tar.gz && rm -f /tmp/reshape2.tar.gz

RUN wget -O /tmp/RColorBrewer.tar.gz https://cran.r-project.org/src/contrib/Archive/RColorBrewer/RColorBrewer_1.1-2.tar.gz && \
    R CMD INSTALL /tmp/RColorBrewer.tar.gz && rm -f /tmp/RColorBrewer.tar.gz

RUN wget -O /tmp/dichromat.tar.gz https://cran.r-project.org/src/contrib/Archive/dichromat/dichromat_2.0-0.tar.gz && \
    R CMD INSTALL /tmp/dichromat.tar.gz && rm -f /tmp/dichromat.tar.gz

RUN wget -O /tmp/colorspace.tar.gz https://cran.r-project.org/src/contrib/Archive/colorspace/colorspace_1.2-4.tar.gz && \
    R CMD INSTALL /tmp/colorspace.tar.gz && rm -f /tmp/colorspace.tar.gz

RUN wget -O /tmp/munsell.tar.gz https://cran.r-project.org/src/contrib/Archive/munsell/munsell_0.5.0.tar.gz && \
    R CMD INSTALL /tmp/munsell.tar.gz && rm -f /tmp/munsell.tar.gz

RUN wget -O /tmp/labeling.tar.gz https://cran.r-project.org/src/contrib/Archive/labeling/labeling_0.3.tar.gz && \
    R CMD INSTALL /tmp/labeling.tar.gz && rm -f /tmp/labeling.tar.gz

RUN wget -O /tmp/scales.tar.gz https://cran.r-project.org/src/contrib/Archive/scales/scales_0.3.0.tar.gz && \
    R CMD INSTALL /tmp/scales.tar.gz && rm -f /tmp/scales.tar.gz

RUN wget -O /tmp/proto.tar.gz https://cran.r-project.org/src/contrib/Archive/proto/proto_0.3-10.tar.gz && \
    R CMD INSTALL /tmp/proto.tar.gz && rm -f /tmp/proto.tar.gz

RUN wget -O /tmp/ggplot2.tar.gz https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_1.0.1.tar.gz && \
    R CMD INSTALL /tmp/ggplot2.tar.gz && rm -f /tmp/ggplot2.tar.gz

RUN wget -O /tmp/gridExtra.tar.gz https://cran.r-project.org/src/contrib/Archive/gridExtra/gridExtra_2.0.0.tar.gz && \
    R CMD INSTALL /tmp/gridExtra.tar.gz && rm -f /tmp/gridExtra.tar.gz

RUN wget -O /tmp/data.table.tar.gz https://cran.r-project.org/src/contrib/Archive/data.table/data.table_1.9.8.tar.gz && \
    R CMD INSTALL /tmp/data.table.tar.gz && rm -f /tmp/data.table.tar.gz

RUN wget -O /tmp/minqa.tar.gz https://cran.r-project.org/src/contrib/Archive/minqa/minqa_1.2.4.tar.gz && \
    R CMD INSTALL /tmp/minqa.tar.gz && rm -f /tmp/minqa.tar.gz

RUN wget -O /tmp/nloptr.tar.gz https://cran.r-project.org/src/contrib/Archive/nloptr/nloptr_1.2.0.tar.gz && \
    R CMD INSTALL /tmp/nloptr.tar.gz && rm -f /tmp/nloptr.tar.gz

RUN wget -O /tmp/lme4.tar.gz https://cran.r-project.org/src/contrib/Archive/lme4/lme4_1.1-10.tar.gz && \
    R CMD INSTALL /tmp/lme4.tar.gz && rm -f /tmp/lme4.tar.gz

RUN wget -O /tmp/curl.tar.gz https://cran.r-project.org/src/contrib/Archive/curl/curl_0.8.tar.gz && \
    R CMD INSTALL /tmp/curl.tar.gz && rm -f /tmp/curl.tar.gz

RUN wget -O /tmp/readr.tar.gz https://cran.r-project.org/src/contrib/Archive/readr/readr_0.1.1.tar.gz && \
    R CMD INSTALL /tmp/readr.tar.gz && rm -f /tmp/readr.tar.gz

RUN wget -O /tmp/lazyeval.tar.gz https://cran.r-project.org/src/contrib/Archive/lazyeval/lazyeval_0.1.10.tar.gz && \
    R CMD INSTALL /tmp/lazyeval.tar.gz && rm -f /tmp/lazyeval.tar.gz

RUN wget -O /tmp/assertthat.tar.gz https://cran.r-project.org/src/contrib/Archive/assertthat/assertthat_0.1.tar.gz && \
    R CMD INSTALL /tmp/assertthat.tar.gz && rm -f /tmp/assertthat.tar.gz

RUN wget -O /tmp/R6.tar.gz https://cran.r-project.org/src/contrib/Archive/R6/R6_2.0.tar.gz && \
    R CMD INSTALL /tmp/R6.tar.gz && rm -f /tmp/R6.tar.gz

RUN wget -O /tmp/magrittr.tar.gz https://cran.r-project.org/src/contrib/Archive/magrittr/magrittr_1.5.tar.gz && \
    R CMD INSTALL /tmp/magrittr.tar.gz && rm -f /tmp/magrittr.tar.gz

RUN wget -O /tmp/DBI.tar.gz https://cran.r-project.org/src/contrib/Archive/DBI/DBI_0.3.1.tar.gz && \
    R CMD INSTALL /tmp/DBI.tar.gz && rm -f /tmp/DBI.tar.gz

RUN wget -O /tmp/dplyr.tar.gz https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.4.0.tar.gz && \
    R CMD INSTALL /tmp/dplyr.tar.gz && rm -f /tmp/dplyr.tar.gz

RUN wget -O /tmp/stringi.tar.gz https://cran.r-project.org/src/contrib/Archive/stringi/stringi_0.4-1.tar.gz && \
    R CMD INSTALL /tmp/stringi.tar.gz && rm -f /tmp/stringi.tar.gz

RUN wget -O /tmp/tidyr.tar.gz https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_0.2.0.tar.gz && \
    R CMD INSTALL /tmp/tidyr.tar.gz && rm -f /tmp/tidyr.tar.gz

RUN wget -O /tmp/pbkrtest.tar.gz https://cran.r-project.org/src/contrib/Archive/pbkrtest/pbkrtest_0.4-4.tar.gz && \
    R CMD INSTALL /tmp/pbkrtest.tar.gz && rm -f /tmp/pbkrtest.tar.gz

RUN wget -O /tmp/SparseM.tar.gz https://cran.r-project.org/src/contrib/Archive/SparseM/SparseM_1.7.tar.gz && \
    R CMD INSTALL /tmp/SparseM.tar.gz && rm -f /tmp/SparseM.tar.gz

RUN wget -O /tmp/quantreg.tar.gz https://cran.r-project.org/src/contrib/Archive/quantreg/quantreg_5.08.tar.gz && \
    R CMD INSTALL /tmp/quantreg.tar.gz && rm -f /tmp/quantreg.tar.gz

RUN wget -O /tmp/car.tar.gz https://cran.r-project.org/src/contrib/Archive/car/car_2.0-26.tar.gz && \
    R CMD INSTALL /tmp/car.tar.gz && rm -f /tmp/car.tar.gz

# Set working directory
WORKDIR /analysis

# Copy data and analysis script
#COPY data ./data
COPY 5.r ./

# Default command
CMD ["Rscript", "./5.r"]