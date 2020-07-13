# Dockerfile for using wheel
FROM sagemath/sagemath:9.1.rc5
USER root
ENV HOME /root
RUN apt-get update && apt-get -qq install -y curl tar less git emacs-nox \
    pandoc texlive-xetex texlive-fonts-recommended texlive-generic-recommended texlive-generic-extra \
    && curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
    && apt-get install -yq nodejs && npm install npm@latest -g
USER sage
ENV HOME /home/sage
RUN sage -pip install --upgrade jupyter_core jupyter_server nbformat nbclient nbconvert pygments voila
RUN sage -pip install --upgrade ipywidgets rise bqplot ipympl
RUN git clone -b develop https://github.com/sagemath/sage-combinat-widgets.git sage-combinat-widgets
RUN git clone -b develop https://github.com/sagemath/sage-explorer.git sage-explorer
RUN git clone -b develop https://github.com/zerline/francy-widget.git francy-widget
COPY --chown=sage:sage *.ipynb ${HOME}/
COPY --chown=sage:sage *.png ${HOME}/
COPY --chown=sage:sage *.json ${HOME}/
RUN mkdir ${HOME}/WomenMathGenealogy
COPY WomenMathGenealogy/* ${HOME}/WomenMathGenealogy/
WORKDIR ${HOME}/sage-combinat-widgets
RUN sage -pip install .
WORKDIR ${HOME}/sage-explorer
RUN sage -pip install .
WORKDIR ${HOME}/francy-widget
RUN sage -pip install .
RUN sage -python3 /home/sage/sage/local/bin/jupyter-nbextension enable --py --sys-prefix jupyter_francy
WORKDIR ${HOME}
