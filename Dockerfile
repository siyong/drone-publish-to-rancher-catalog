FROM node

ADD publish-chart.sh /bin/
CMD [ "/bin/publish-chart.sh" ]
