namespace Vessel {
    
    public class Utf8InputStream : Object {
        public DataInputStream base_stream { get; construct; }
        private string _line = "";
        private size_t _line_len = 0;
        private size_t _line_offset = 0;

        public Utf8InputStream (InputStream base_stream) throws IOError {
            Object (base_stream: new DataInputStream (base_stream));
        }

        public bool at_end_of_line { get { return _line_offset >= _line_len; } }

        public uint lineno { get; private set; }

        /**
         * Advance to the next line in the data. On the first call, advances to the
         * first line.
         */
        public bool next_line () throws IOError {
            string? data = base_stream.read_line_utf8 ();
            if (data == null)
                return false;
            _line = data.strip ();
            _line_len = _line.length;
            _line_offset = 0;
            lineno += 1;
            return true;
        }

        public char peek_char () {
            return _line[(long)_line_offset];
        }

        public float parse_float () throws IOError {
            float value = 0;
            char *p = (char *)_line + _line_offset;
            unowned string end_p = (string)p;

            while (*p != '\0' && p->isspace ())
                p++;

            float.try_parse ((string)p, out value, out end_p);
            if ((char *)end_p - (char *)p == 0)
                throw new IOError.INVALID_DATA ("unexpected character %c in float", end_p[0]);

            _line_offset = (char *)end_p - (char *)_line;
            return value;
        }

        public int parse_int () throws IOError {
            int value = 0;
            char *p = (char *)_line + _line_offset;
            unowned string end_p = (string)p;

            while (*p != '\0' && p->isspace ())
                p++;

            int.try_parse ((string)p, out value, out end_p);
            if ((char *)end_p - (char *)p == 0)
                throw new IOError.INVALID_DATA ("unexpected character %c in int", end_p[0]);

            _line_offset = (char *)end_p - (char *)_line;
            return value;
        }

        /**
         * Reads the rest of the current line after any spaces.
         */
        public string read_string () {
            char *p = (char *)_line + _line_offset;

            while (*p != '\0' && p->isspace ())
                p++;

            char *old_p = p;
            while (*p != '\0')
                p++;

            _line_offset = (char *)p - (char *)_line;
            return (string)old_p;
        }

        public bool skip_symbol (string to_skip) {
            char *p = (char *)_line + _line_offset;
            
            while (*p != '\0' && p->isspace ())
                p++;

            char *old_p = p;
            while (*p != '\0' && to_skip[(long)(p - old_p)] == *p)
                p++;

            if (p - old_p != to_skip.length || *p != '\0' && !p->isspace ())
                return false;

            _line_offset = p - (char *)_line;
            return true;
        }

        public bool skip_char (char to_skip) {
            char *p = (char *)_line + _line_offset;
            
            if (*p != '\0' && *p == to_skip)
                p++;
            else
                return false;

            _line_offset = p - (char *)_line;
            return true;
        }
    }
}