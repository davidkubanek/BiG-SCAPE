FROM conda/miniconda3

RUN apt-get update && apt-get install -y git wget

SHELL ["/bin/bash", "-c"]
WORKDIR /usr/src

# Cloning BiG-SCAPE
RUN git clone https://github.com/davidkubanek/BiG-SCAPE.git

# Create conda environment
RUN conda env create -f /usr/src/BiG-SCAPE/bigscape_dependencies.yml
RUN echo "source activate bigscape" > ~/.bashrc
ENV PATH /usr/local/envs/bigscape/bin:$PATH
ENV PATH /usr/src/BiG-SCAPE:$PATH

RUN cd BiG-SCAPE \
 && wget https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz \
 && gunzip Pfam-A.hmm.gz \
 && source activate bigscape \
 && hmmpress Pfam-A.hmm \
 && chmod +x /usr/src/BiG-SCAPE/*py \
 && chmod a+w /usr/src/BiG-SCAPE/domains_color_file.tsv \
 && chmod a+w /usr/src/BiG-SCAPE/Annotated_MIBiG_reference/ \
 && chmod 777 /home

USER 1000:1000
RUN mkdir /home/input /home/output
WORKDIR /home
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENTRYPOINT ["bigscape.py"]
CMD ["--help"]
