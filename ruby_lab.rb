
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Mitchell Black
# mitchell.g.black@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Mitchell Black"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|

			title = cleanup_title line # clean up title

			unless title.eql? nil # check if passed test for only English chars

				words = title.chomp.split(/\s+/) # split into words

				words.each_with_index do |word, i|

					unless i == words.length - 1	# check if current word is last in title

						# to count bigrams, we use nested hashes.
						# the first hash takes a word and links to the second hash
						# the second hash takes the following word and stores its frequency

						if($bigrams.member?(word))	# check if word has been added to hash
							if($bigrams[word].member?(words[i+1])) # check if next word has been add to sub-hash
								$bigrams[word][words[i+1]] = $bigrams[word][words[i+1]] + 1 # increment if next word has been added
							else
								$bigrams[word][words[i+1]] = 1 # first count of next words
							end # end of inner membership if-else
						else # if this is the fist time word has appeared, the word is given its own has
							$bigrams[word] = Hash.new
							$bigrams[word][words[i+1]] = 1
						end # end of membership if-else
					end # end of unless
				end # end of words for each
			end #end of file foreach
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

def cleanup_title(line)
	line.gsub!(/.*<SEP>/,"")    # removing everything up to the last <SEP>

	# removing unnecessary text following title
	line.gsub!(/\(.*/,"")
	line.gsub!(/\[.*/,"")
	line.gsub!(/\{.*/,"")
	line.gsub!(/\\.*/,"")
	line.gsub!(/\/.*/,"")
	line.gsub!(/_.*/,"")
	line.gsub!(/-.*/,"")
	line.gsub!(/:.*/,"")
	line.gsub!(/".*/,"")
	line.gsub!(/`.*/,"")
	line.gsub!(/\+.*/,"")
	line.gsub!(/=.*/,"")
	line.gsub!(/\*.*/,"")
	line.gsub!(/feat\..*/,"")

	# removing punctuation in title
	line.gsub!(/\?/,"")
	line.gsub!(/¿/,"")
	line.gsub!(/!/,"")
	line.gsub!(/¡/,"")
	line.gsub!(/\./,"")
	line.gsub!(/;/,"")
	line.gsub!(/&/,"")
	line.gsub!(/@/,"")
	line.gsub!(/%/,"")
	line.gsub!(/#/,"")
	line.gsub!(/\|/,"")

	line.downcase!

	# removing stop words from the title
	line.gsub!(/\ba\b/,"")
	line.gsub!(/\ban\b/,"")
	line.gsub!(/\band\b/,"")
	line.gsub!(/\bby\b/,"")
	line.gsub!(/\bfor\b/,"")
	line.gsub!(/\bfrom\b/,"")
	line.gsub!(/\bin\b/,"")
	line.gsub!(/\bof\b/,"")
	line.gsub!(/\bon\b/,"")
	line.gsub!(/\bor\b/,"")
	line.gsub!(/\bout\b/,"")
	line.gsub!(/\bthe\b/,"")
	line.gsub!(/\bto\b/,"")
	line.gsub!(/\bwith\b/,"")

	unless line =~ /[^\d\w\s']/
		return line
	end

	return nil
end # end of cleanup_title

def mcw(word)

	if($bigrams.member?(word))
		max_val = 0
		max_key = ""
		$bigrams[word].each do |key, val|
			if val > max_val
				max_key = key
				max_val = val
			end
		end
		return max_key
	else
		return nil
	end

end # end of mcw

def create_title(name)
	curr_word = name # setting the current word to the enter word
	while curr_word != nil # checking if the current word is nil
			curr_word = mcw(curr_word) # setting the new current word based on the last current word
			if name =~ /\b#{curr_word}\b/ # checking if the current word already appears in the song title
				curr_word = nil # if it does, the current word is set to nil so the loop will terminate
			else
	 			name = name +  " " + curr_word # if not, then the current word is appended to the song title
			end
	end
	name
end # end of create_title

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
	run = true # setting the initial loop condition to true
	while run
		print "Enter a word [enter 'q' to quit]: " # prompting user for seed word
		word = $stdin.gets.chomp # taking seed word from user
		if word == 'q' # checking if user requested to terminate the program
			run = false # if so, setting loop condition to false
		elsif word =~ /[^\w\d]/ # checking if the user entered a single word
			puts "You must enter a single word. Please try again."
		else
			if $bigrams.member?(word) # if the word appears in the list of song titles
																# then create title is called

				puts create_title(word) # printing generated song title
			else
				puts "#{word} does not appear in any song titles. Please try again."
			end
		end
	end
end

if __FILE__==$0
	main_loop()
end
