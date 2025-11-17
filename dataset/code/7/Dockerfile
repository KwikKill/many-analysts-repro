FROM thebloodman/r-old:3.0.2

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cran.r-project.org/"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install R packages (use archive URLs for old versions)
RUN wget -O /tmp/Matrix.tar.gz https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.1-5.tar.gz && \
    R CMD INSTALL /tmp/Matrix.tar.gz && rm -f /tmp/Matrix.tar.gz

RUN wget -O /tmp/Rcpp.tar.gz https://cran.r-project.org/src/contrib/Archive/Rcpp/Rcpp_0.11.6.tar.gz && \
    R CMD INSTALL /tmp/Rcpp.tar.gz && rm -f /tmp/Rcpp.tar.gz

RUN wget -O /tmp/inline.tar.gz https://cran.r-project.org/src/contrib/Archive/inline/inline_0.3.10.tar.gz && \
    R CMD INSTALL /tmp/inline.tar.gz && rm -f /tmp/inline.tar.gz

RUN wget -O /tmp/RcppEigen.tar.gz https://cran.r-project.org/src/contrib/Archive/RcppEigen/RcppEigen_0.3.2.5.1.tar.gz && \
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

RUN wget -O /tmp/lme4.tar.gz https://cran.r-project.org/src/contrib/Archive/lme4/lme4_0.999999-2.tar.gz && \
    R CMD INSTALL /tmp/lme4.tar.gz && rm -f /tmp/lme4.tar.gz

RUN wget -O /tmp/curl.tar.gz https://cran.r-project.org/src/contrib/Archive/curl/curl_0.8.tar.gz && \
    R CMD INSTALL /tmp/curl.tar.gz && rm -f /tmp/curl.tar.gz

RUN wget -O /tmp/readr.tar.gz https://cran.r-project.org/src/contrib/Archive/readr/readr_0.1.1.tar.gz && \
    R CMD INSTALL /tmp/readr.tar.gz && rm -f /tmp/readr.tar.gz

#RUN wget -O /tmp/tidyr.tar.gz https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_0.2.0.tar.gz && \
#    R CMD INSTALL /tmp/tidyr.tar.gz && rm -f /tmp/tidyr.tar.gz

RUN wget -O /tmp/DataCombine.tar.gz https://cran.r-project.org/src/contrib/Archive/DataCombine/DataCombine_0.1.10.tar.gz && \
    R CMD INSTALL /tmp/DataCombine.tar.gz && rm -f /tmp/DataCombine.tar.gz

RUN wget -O /tmp/gamlss.dist.tar.gz https://cran.r-project.org/src/contrib/Archive/gamlss.dist/gamlss.dist_4.3-1.tar.gz && \
    R CMD INSTALL /tmp/gamlss.dist.tar.gz && rm -f /tmp/gamlss.dist.tar.gz

RUN wget -O /tmp/plotrix.tar.gz https://cran.r-project.org/src/contrib/Archive/plotrix/plotrix_3.5-10.tar.gz && \
    R CMD INSTALL /tmp/plotrix.tar.gz && rm -f /tmp/plotrix.tar.gz

RUN wget -O /tmp/PReMiuM.tar.gz https://cran.r-project.org/src/contrib/Archive/PReMiuM/PReMiuM_3.0.32.tar.gz && \
    R CMD INSTALL /tmp/PReMiuM.tar.gz && rm -f /tmp/PReMiuM.tar.gz

RUN wget -O /tmp/Cairo.tar.gz https://cran.r-project.org/src/contrib/Archive/Cairo/Cairo_1.5-6.tar.gz && \
    R CMD INSTALL /tmp/Cairo.tar.gz && rm -f /tmp/Cairo.tar.gz

# App apt dependencies
RUN apt-get update && apt-get install -y \
    libxt6 \
    libxrender1

# Set working directory
WORKDIR /analysis

# Copy data and analysis script
#COPY data ./data
COPY 7.r ./

# Default command
CMD ["Rscript", "./7.r"]
