all:
	docker build -t repro-5 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/crowdstorming.csv repro-5