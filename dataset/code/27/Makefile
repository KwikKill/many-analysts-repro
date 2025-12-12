all:
	docker build -t repro-27 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/data/crowdstorming.csv repro-27