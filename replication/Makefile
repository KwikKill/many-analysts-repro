all:
	docker build -t repro-team-30 .
	docker run -v ../dataset/data/CrowdstormingDataJuly1st.csv:/data/CrowdstormingDataJuly1st.csv -v .:/app repro-team-30
