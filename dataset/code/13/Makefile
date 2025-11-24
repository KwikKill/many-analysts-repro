all:
	docker build -t repro-13 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/Crowdstorming.csv repro-13 > output.txt